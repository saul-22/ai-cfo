---
description: 个股或主题独立研究（纯净模式）。调用 research-isolated agent，物理隔离当前持仓。
argument-hint: <研究问题>
---

用户的研究问题：**$ARGUMENTS**

**强制执行：**

1. **不读** `investment/EXECUTION-CONTEXT.md`、`investment/holding-summary.md`、`investment/portfolio-config.txt`、`investment/portfolio-versions.md`、CLAUDE.md "当前组合"段。
2. 立即调用 Agent 工具，`subagent_type: "research-isolated"`。prompt 把用户问题原样转述给 agent，不带"用户现在持仓..."类上下文。
3. **报告回流规则：** agent 输出后，主 Claude **原样转述** + 顶部加一行 `[独立分析，未对照当前持仓]`。**禁止**主动"和当前组合对比"、"和你现在持仓差在哪"。除非用户明确要求对比。
