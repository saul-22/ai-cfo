---
description: 白纸构建组合（纯净模式）。调用 greenfield-isolated agent，物理隔离当前组合。
---

**强制走 `research/runbook-A-greenfield.md` 流程，调用 Agent 工具 `subagent_type: "greenfield-isolated"` 跑，主 Claude 不参与推导。**

**主 Claude 只做 3 件事：**
1. 调用 greenfield-isolated agent
2. 等 agent 输出
3. 原样转述报告，顶部标注 `[白纸构建，未对照当前组合]`

prompt 给 agent：`按 runbook-A 6 步推导理论最优组合（IPS / Regime / SAA / 候选池 / 数学化权重 / 压力测试），月投入按 ips.md 配置，长期窗口（参考 ips.md 第 2 节）。`

**禁止：** 主 Claude 收到报告后**不得**主动加"和当前组合对比"段、"建议执行"段。用户主动要对比时另起话题再做。
