---
description: 周风控扫描（每周日触发，4 必做项 5-10 分钟）
---

进入**周风控模式**。严格按 `investment/runbooks/weekly-risk-scan.md` 4 项必跑流程：

**Step 0：读 2 文件**
1. **`investment/EXECUTION-CONTEXT.md`**（当前组合 + 信念 — 默认不加载，执行模式必读）
2. `investment/holding-summary.md` 获取当前持仓列表

**Step 1：大盘距 ATH**
- WebSearch / FMP 拉大盘指数当前价 + 52 周高
- 计算 `(当前价 - ATH) / ATH`
- 判定 🟢/🟡/🟠/🔴

**Step 2：持仓最大周跌幅**
- 每只持仓周一价 vs 当前价
- 找最大跌者
- 判定 🟢/🟡/🟠/🔴

**Step 3：本币汇率周变化（如跨境投资）**
- 当前汇率 vs 一周前
- 判定 🟢/🟡/🟠/🔴

**Step 4：持仓重大负面新闻**
- WebSearch 每只持仓过去 7 天
- 关键词：SEC investigation / CEO / earnings warning / downgrade / lawsuit / fraud
- 判定 🟢/🟡/🟠/🔴

**Step 5：综合判定 + 输出**
按 runbook "输出格式" 段追加到 `investment/records/scan-history.md` 周风控段，含 4 项判定 + 综合判定 + 下一步 + 元数据（version / items-completed / generated-at）。

🔴 立即触发 emergency-audit。
🟠 连续 2 周升级 🔴。
🟢 30 秒汇报完，无 hedging。

**缺任一项 = 作废重跑。**
