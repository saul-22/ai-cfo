#!/bin/bash
# PostToolUse hook: 改 investment/ 下文件后自动 git add + commit + push
#
# 触发：Write/Edit/MultiEdit 工具完成 + 目标路径在 investment/ 内
# 动作：自动加入 git，commit 信息从修改的文件名推断，push 到 origin/main
#
# 不触发的情况（避免噪音）：
#   - 改 archive/ 下文件（归档操作，会单独被 chore: archive commit）
#   - 改受保护文件（已经走过提案流程，必须由 Claude 手动 commit 带 thesis）

set -e

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$HOOK_DIR/../.." && pwd)"

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('tool_name', ''))" 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('tool_input', {}).get('file_path', ''))" 2>/dev/null || echo "")

# 只处理 Write/Edit/MultiEdit
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "MultiEdit" ]]; then
    exit 0
fi

# 必须在 investment/ 下
if [[ "$FILE_PATH" != "$PROJECT_DIR/investment/"* ]]; then
    exit 0
fi

# 跳过 archive/（归档操作单独 commit）
if [[ "$FILE_PATH" == *"/archive/"* ]]; then
    exit 0
fi

# 跳过受保护文件（必须手动 commit 带 thesis）
case "$FILE_PATH" in
    "$PROJECT_DIR/investment/portfolio-config.txt"|"$PROJECT_DIR/investment/portfolio-versions.md")
        exit 0
        ;;
esac

cd "$PROJECT_DIR"

# 检查文件是否真有变更
if ! git diff --quiet -- "$FILE_PATH" 2>/dev/null; then
    HAS_CHANGE=true
elif ! git diff --cached --quiet -- "$FILE_PATH" 2>/dev/null; then
    HAS_CHANGE=true
elif ! git ls-files --error-unmatch "$FILE_PATH" >/dev/null 2>&1; then
    # 新增的未追踪文件
    HAS_CHANGE=true
else
    HAS_CHANGE=false
fi

if [[ "$HAS_CHANGE" != "true" ]]; then
    exit 0
fi

# 推断 commit type
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
case "$REL_PATH" in
    investment/records/investment-ledger.md|investment/holding-summary.md|investment/performance.md)
        TYPE="update"
        ;;
    investment/records/scan-history.md)
        TYPE="audit"
        ;;
    investment/records/decision-journal.md)
        TYPE="update"
        ;;
    investment/buy-order.txt)
        TYPE="buy"
        ;;
    investment/playbooks/*|investment/runbooks/*)
        TYPE="chore"
        ;;
    *)
        TYPE="update"
        ;;
esac

FILE_NAME=$(basename "$FILE_PATH")

git add "$FILE_PATH"
git commit -m "$TYPE: 自动提交 $FILE_NAME

PostToolUse hook 自动触发（$(date '+%Y-%m-%d %H:%M')）
文件：$REL_PATH

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>" >&2 2>&1 || {
    echo "[auto-commit] commit 失败：$REL_PATH" >&2
    exit 0
}

# push 到 origin/main（失败不阻断）
git push origin main >&2 2>&1 || {
    echo "[auto-commit] push 失败（可能离线），稍后手动 push" >&2
}

exit 0
