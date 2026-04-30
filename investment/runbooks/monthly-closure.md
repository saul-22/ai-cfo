# 月度闭环强制 Runbook（3 步）

> 用户反馈"已按比例买了"后必走。
> 核心原则：ledger 是事实源，其他文件是衍生快照。

---

## 触发

用户反馈"已按比例买了"或"本月定投已执行"。

**如果用户同时提供当日价格/汇率** → 直接用；
**如果没提供** → Claude 用当日收盘价 + 当日汇率自己估算（不再追问）。

---

## 3 步闭环

### Step 1：更新 ledger（事实源）

在 `records/investment-ledger.md` 追加当月段，最小字段：

```markdown
### YYYY年M月
**状态：** 已估算（年度 <券商> 对账校正）
**日期：** YYYY-MM-DD
**汇率：** X.XX（当日 USD/<currency>）
**总投入：** <证券预算> <currency> 证券（按当前版本比例） + <现金预算> <currency> 现金
**参考价：** <TICKER1> $xxx / <TICKER2> $xxx / ...（YYYY-MM-DD 收盘价）
**分红：** [用户已查：<currency> X / 用户未查 / 无]
**备注：** [异常事项，无则"按当前版本模板正常执行"]
```

同时更新 ledger 顶部"汇总表"追加一行。

如有分红 → 在当月段末追加"分红记录"表。

### Step 2：重算 holding-summary + 追加 performance 月度行

**`holding-summary.md`**：全量覆盖（当前驾驶舱）
- 本月状态（3 行：ledger 已更新 ✅ / 驾驶舱已刷 ✅ / git 已推 ✅）
- 组合总览（累计投入、当前市值、累计回报）
- 实际持仓表（每只：成本均价 / 当前价 / 市值 / 收益率 / 实际权重 / 目标权重 / 偏离）
- 穿透后风险暴露
- 再平衡/风控信号（偏离 / 穿透 / 紧急 均判定一次）
- 下月动作建议 + 分红核查提醒

**`performance.md` 月度明细**：追加一行（历史永不改）
- 月份 / 当月新投入 / 月末市值 / 当月回报 / 累计投入 / 累计市值 / 累计回报 / 关键事件

**其他衍生区块**（累计概览、单股、分层、benchmark）：全量重算覆盖。

### Step 3：git commit + push

```bash
git add investment/records/investment-ledger.md investment/holding-summary.md investment/performance.md
git commit -m "buy: YYYY-MM 月度闭环

证券 <currency> X,XXX + 现金 <currency> XXX，汇率 X.XX
累计市值 <currency> XXX，累计回报 +X.XX%
无触发偏离/穿透/紧急

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>"
git push origin main
```

---

## 何时**不**走 3 步（而是扩展流程）

| 情况 | 追加动作 |
|---|---|
| 偏离 ≥ 5%（某只）| 写 `records/decision-journal.md` + 下月 buy-order 增量校正 |
| 穿透 > 单股上限（某只）| 立即跑 `emergency-audit.md` |
| 单股 -40% / 重大负面 / 大盘 -20% | 立即 `emergency-audit.md` |
| 里程碑（$60k / 100 万 / 300 万 / 500 万）| 写 `research/proposals/phase-XXX.md` |
| 用户选择调整比例 / 换股 | 走提案流程（不是闭环）|

上述触发时，3 步闭环**仍然先走完**，然后加 Step 4 对应动作。

---

## 输出：月度闭环报告

```
📊 YYYY-MM 月度闭环完成（3 步）

实际：证券 <currency> X,XXX + 现金 <currency> XXX，汇率 X.XX
市值：<currency> XXX，当月 +X.X% / 累计 +X.X%
风控：穿透 <某股> X%（≤上限）/ 最大偏离 ±X%（≤5%）
触发：无偏离/穿透/紧急
下月：Y/25 按当前版本继续执行

---
monthly-closure-runbook-version: <N>
steps-completed: 3/3
generated-at: YYYY-MM-DD HH:MM
---
```

---

## 硬规则

- 3 步顺序不可乱
- Step 1 ledger 是事实源，其他都从它重算
- Step 2 不再手工同步"5 个文件的累计回报"
- Step 3 必须 push
- records/decision-journal 只在真事件时写，按当前版本模板买不写

---

## 版本

- 初始版本：基础多步流程
- 后续迭代：精简为 3 步（ledger 单一事实源 + holding-summary/performance 衍生重算 + decision-journal 事件驱动）
