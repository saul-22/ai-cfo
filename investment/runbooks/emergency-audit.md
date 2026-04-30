# 紧急审核强制 Runbook

> 紧急触发器激活时 24 小时内必走。
> 产出 HOLD / REDUCE / EXIT 决策。
> 跳步 = 作废。

---

## 触发条件（任一）

1. 单只持仓季度内跌 >40%
2. 持仓公司 SEC 调查 / 财务造假 / CEO 离职
3. 大盘指数单季跌 >20%（熊市确认）
4. 单只持仓单周跌 >40%（周风控升级）
5. 持仓公司重大产品/监管风险事件（如关键药物 FDA 拒绝、关键芯片出口禁令）

---

## 时间窗口

**24 小时内完成全部 7 步。** 超时 = 风险窗口扩大，决策质量降低。

---

## 7 步（顺序不可乱）

### Step 1：事件确认（≤ 10 分钟）

**必做：**
- WebSearch 确认事件真实性（不信单一媒体）
- 拉股票当前价 + 事件前价
- 计算实际跌幅

**产出：** 事件摘要 + 数据（事件时间、来源、跌幅、成交量变化）

**校验：** 如事件为假消息或夸大 → 降级为周风控监控，终止本流程。

### Step 2：基本面影响评估（≤ 30 分钟）

**必做：**
- 用 `ancs21/warren-buffett` 重新评估护城河
- 用 `ancs21/ben-graham` 重新评估估值（跌后 PE/PB）
- 用 `fscore-screener` 重新评估财务健康
- 用 `ancs21/charlie-munger` 反向：这事件让基本面永久恶化了吗？

**产出：** 基本面评估表（4 维度 × 事件前/事件后）

**关键判断：** 事件是**暂时性冲击**还是**永久性恶化**？

### Step 3：组合影响测算（≤ 20 分钟）

**必做：**
- 当前 holding-summary 数据 + 该股最新价
- 算该股对组合的拖累（仓位 × 跌幅）
- 算穿透后是否超单股上限
- 算剩余组合的实际暴露

**产出：** 组合影响表 + 是否触发风控硬线（单股穿透超上限、板块超上限）

### Step 4：宏观环境评估（≤ 20 分钟）

**必做：**
- 是单只事件还是系统性风险？
- 跑 `macro-regime-detector` 简化版（4 比率）
- 对比 2008/2020/2022 相似情景（`scenario-analyzer`）

**产出：** 环境判定 + 类似历史情景 + 彼时后续走势

### Step 5：决策方案（≤ 30 分钟）

**三选一：**

**A. HOLD（持有不动）**
- 事件是暂时性冲击
- 基本面 3+ 个 filter 仍 PASS
- 组合风控未破线
- 历史情景显示通常 6-12 月恢复

**B. REDUCE（减仓）**
- 基本面 2 个 filter 转 FAIL
- 或穿透后单股超过单股上限
- 减仓到多少：用 Kelly/4 重新计算（`joellewis/bet-sizing`）
- 腾出资金暂时进 T4 现金

**C. EXIT（清仓）**
- 基本面 4+ 个 filter FAIL（永久恶化）
- 或出现"致命"信号（财务造假、SEC 立案、CEO 跑路）
- 清仓后资金全进 T4 现金，等季度扫描决定去向

### Step 6：Munger 反向（必做，≤ 15 分钟）

**必答：**
- 我现在的决策 5 年后会后悔吗？
- 如果我决定错了，损失多大？
- 如果市场明天反转，我的决策还成立吗？
- 什么信息我现在看不到但重要？

**产出：** 至少 3 个 failure mode + 缓解方案

### Step 7：执行 + 归档（≤ 1 小时）

**如决策是 HOLD：**
- 写入 `research/emergency/YYYY-MM-DD-ticker/audit.md`
- 追加 `records/scan-history.md` 紧急审核段
- 追加 `records/decision-journal.md`（心态 + 决策依据）
- **不修改 portfolio-config**

**如决策是 REDUCE/EXIT：**
- 写 `research/proposals/swap-emergency-ticker.md` 或 `remove-ticker.md` 提案
- 标注"紧急类型，无冷却期"
- 启动独立 Agent 复审
- Agent PASS → 用户批准 → 创建 `.proposal-approved` → 改 portfolio-config
- 同日执行<券商>操作

---

## 输出格式（必须）

```markdown
# 紧急审核：[TICKER] - [YYYY-MM-DD]

## 事件
[Step 1 摘要]

## 基本面影响
[Step 2 表]

## 组合影响
[Step 3 数据]

## 宏观环境
[Step 4 判定]

## 决策
**HOLD / REDUCE / EXIT**

依据：
- [Step 2 基本面]
- [Step 3 风控]
- [Step 4 环境]

## Munger 反向
[Step 6 failure modes]

## 执行
[Step 7 动作]

---
emergency-runbook-version: 1.0
steps-completed: 7/7
event-date: YYYY-MM-DD
decision-made-at: YYYY-MM-DD HH:MM
decision: HOLD / REDUCE / EXIT
---
```

---

## 硬规则

- 24 小时内必须完成（非可选）
- 7 步全跑（禁止跳 Munger 反向）
- 决策必须是 HOLD/REDUCE/EXIT 三选一，不允许"再等等"
- 如决策是"再等等"，默认按 HOLD 处理（不等同于决策缺失）
- REDUCE/EXIT 必须走提案流程 + 独立 Agent 复审
- 紧急事件无冷却期（portfolio-config 定义）

---

## 版本

v1.0 初始版本。
