---
description: 月度定投流程（每月 25 日，生成 buy-order.txt 给用户执行）
---

进入**月度执行模式**。按以下顺序：

**Step 0：归档当前 buy-order**
- 复制 `investment/buy-order.txt` → `investment/archive/YYYY/buy-order-YYYY-MM.txt`（YYYY-MM = 上月）
- 在 `investment/archive/YYYY/INDEX.md` 追加一行
- **禁止先覆盖 buy-order.txt 再归档**（顺序错会丢上月数据）

**Step 1：读 5 文件**
1. **`investment/EXECUTION-CONTEXT.md`**（当前组合 + 信念 + 历史决策 — 默认不加载，执行模式必读）
2. `investment/portfolio-config.txt`（目标比例、风控规则）
3. `investment/holding-summary.md`（当前偏离）
4. `investment/records/scan-history.md`（最近风控结论 + 监控级标的）
5. `investment/records/decision-journal.md`（上次 thesis）

**Step 2：日历触发器检查**
- 紧急触发器：单股 -40% / SEC / CEO / 财务造假 / 大盘 -20%（任一激活则先停下跑 emergency-audit）
- 偏离 ±5% 增量校正、±10% 年度调仓
- 个股特别条款（按 `portfolio-config.txt` 定义，如营收增速黄/红灯阈值）

**Step 3：调用 monthly-portfolio-plan skill**
- 拉实时价（FMP / .env.local）
- 计算每只目标金额 + 股数（取整数）+ 总金额
- 用本币规划（若跨境，汇率从 FMP）

**Step 4：风控审核（stock-audit skill）**
对当月主要买入标的（金额超过 `portfolio-config.txt` 阈值的）跑快速 audit，确认没有红灯。

**Step 5：生成 `investment/buy-order.txt`**
完整覆盖。包含：
- 本月日期
- 各标的股数 + 价格 + 金额
- 总金额
- 执行说明（券商限价单）
- 闭环回填字段（实际成交价 / 时间 / 股数）

**Step 6：写 thesis 到 `decision-journal.md`**
追加一段：当时为什么这样配（即便完全按当前版本）+ 担心什么 + 3/12/36 月预测。

**Step 7：交付给用户**
打印 buy-order 摘要。提醒：
- 定投日早盘下单（限价单 = 当前价 +0.5%）
- 反馈成交时**必须查分红**（券商 → Confirmations → Dividend）
- 闭环时跑 `monthly-closure.md` runbook

**禁止跳步**。
