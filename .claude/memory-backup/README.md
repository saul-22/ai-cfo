# 记忆备份目录

> 这是 Claude Code home 目录下记忆文件（`~/.claude/projects/<project-id>/memory/`）的 Git 镜像备份。
> 防止 home 目录下的记忆文件被误删或系统清理时丢失。

## 备份规则

**触发时机：** 每次 Claude 写入或修改 home 目录下记忆文件后，必须立刻同步到本目录。

**同步命令模板：**
```bash
# 把 <PROJECT_ID> 替换为你本地 ~/.claude/projects/ 下的实际目录名
cp ~/.claude/projects/<PROJECT_ID>/memory/*.md \
   ${CLAUDE_PROJECT_DIR}/.claude/memory-backup/
```

**恢复命令（home 目录记忆丢失时）：**
```bash
cp ${CLAUDE_PROJECT_DIR}/.claude/memory-backup/*.md \
   ~/.claude/projects/<PROJECT_ID>/memory/
```

## 注意

- **主位置**：`~/.claude/projects/<PROJECT_ID>/memory/`（Claude Code 读取的位置）
- **备份位置**：本目录（Git 追踪，云端同步到你的 Git 远程）
- **冲突规则**：主位置是权威；备份只用于恢复
- 不要直接编辑本目录的文件——改完主位置后 Claude 会同步过来

## 通用框架记忆（项目自带，不要删）

以下是 ai-cfo 框架自带的通用记忆，对所有用户都适用：

- `pm_responsibility.md` — 资深投资经理责任（最高优先级）
- `rationality_constraints.md` — 理性约束（防讨好型回答）
- `proposal_discipline.md` — 提案纪律（变更前必跑触发检查）
- `feedback_rigor_mismatch.md` — 严谨错配警惕

## 用户自定义记忆

你的 IPS / 偏好 / 历史决策等会写入主位置 memory，本目录只做镜像。
不要把项目自带的通用记忆删掉，那是框架的一部分。
