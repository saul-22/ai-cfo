#!/bin/bash
# PreToolUse hook: 拦截对投资核心文件的写入，强制触发条件检查
#
# 触发条件：Write/Edit/MultiEdit 工具 + 目标路径匹配关键文件
# 动作：检查提案是否有"复审 PASS"标记，无则拒绝
#
# 关键保护文件（项目根相对路径）：
#   - investment/portfolio-config.txt（组合配置真相源）
#   - investment/portfolio-versions.md（版本档案）
#   - ips.md（投资宪法）

set -e

# 项目根 = hook 所在目录的上两级
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$HOOK_DIR/../.." && pwd)"

# 从 stdin 读取 Claude Code 传入的 JSON
INPUT=$(cat)

# 解析工具和参数
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('tool_name', ''))")
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('tool_input', {}).get('file_path', ''))")

# 只检查 Write/Edit/MultiEdit 工具
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "MultiEdit" ]]; then
    exit 0
fi

# 规范化路径（去掉 . .. 符号链接）
NORMALIZED_FILE_PATH=$(cd "$(dirname "$FILE_PATH" 2>/dev/null)" 2>/dev/null && pwd 2>/dev/null)/$(basename "$FILE_PATH" 2>/dev/null) || NORMALIZED_FILE_PATH="$FILE_PATH"

# 受保护的文件（相对项目根）
PROTECTED_REL_PATHS=(
    "investment/portfolio-config.txt"
    "investment/portfolio-versions.md"
    "ips.md"
)

IS_PROTECTED=false
for rel_path in "${PROTECTED_REL_PATHS[@]}"; do
    protected_abs="$PROJECT_DIR/$rel_path"
    if [[ "$FILE_PATH" == "$protected_abs" ]] || [[ "$NORMALIZED_FILE_PATH" == "$protected_abs" ]]; then
        IS_PROTECTED=true
        break
    fi
done

if [[ "$IS_PROTECTED" == "false" ]]; then
    exit 0
fi

# 检查是否存在"已批准的提案"标记文件
APPROVAL_MARKER="$PROJECT_DIR/.claude/.proposal-approved"

if [[ -f "$APPROVAL_MARKER" ]]; then
    # 检查标记是否在过去 1 小时内生成（防止老标记被复用）
    MARKER_AGE=$(( $(date +%s) - $(stat -f %m "$APPROVAL_MARKER") ))
    if [[ $MARKER_AGE -lt 3600 ]]; then
        # 标记有效，允许写入。使用后立即删除
        rm "$APPROVAL_MARKER"
        exit 0
    fi
fi

# 无批准标记 → 拒绝
cat >&2 << EOF
🛑 HOOK 拒绝写入：受保护文件需要提案流程

被拦截文件：$FILE_PATH
属于"投资真相源"，不能直接修改。必须：

1. 在 research/proposals/ 生成提案文件
2. 启动独立 Agent 复审（见 CLAUDE.md "提案独立复审"）
3. Agent 返回 PASS
4. 用户明确说"批准提案 [文件名]"
5. Claude 创建批准标记（项目根执行）：
   touch .claude/.proposal-approved
6. 1 小时内执行此 Write/Edit（标记会被自动消耗）

如果是初始建仓 / typo 修复等合理直接写入：
用户在 Terminal 手动（项目根）：
  touch .claude/.proposal-approved
然后 Claude 可在 1 小时内执行写入。
EOF

exit 2
