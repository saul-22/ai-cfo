---
description: 跑完整会话启动 SOP（执行模式）：读 6 文件 + 日历 + 5 段开场白
---

进入**执行模式**。严格按 CLAUDE.md "🚨 会话启动 SOP" 第 0-2 步执行：

**Step 0：依次读 9 文件**
1. **`investment/EXECUTION-CONTEXT.md`**（当前组合 + 信念 + 历史决策 — 默认不加载，执行模式必读）
2. `investment/monthly-process.md`
3. `investment/holding-summary.md`
4. `investment/performance.md`
5. `investment/buy-order.txt`
6. `investment/records/scan-history.md`
7. `investment/records/decision-journal.md`
8. `research/methodology.md`
9. `ips.md`

**Step 1：日历检查**
今天 vs 未来 7 天 — 列出落在窗口内的关键日期（定投日、季度扫描、年度 review、W-8BEN 续签如适用、财报集中日、跨年归档）。

**Step 2：5 段式开场白**
```
📍 当前进度：[本月流程第 X 步 / 上次会话遗留]
💼 最新持仓：[市值 <currency> XX，收益率 ±X%，是否偏离告警]
📋 待办事项：[本月待执行项 / 即将到来的关键日期]
⚠️ 风险监控：[scan-history 中标记的监控级标的 / 最新宏观警示]
👉 建议下一步：[具体行动 + 为什么]
```

输出完毕后等用户下一步指令，禁止跳过任何文件、禁止凭印象答。

$ARGUMENTS
