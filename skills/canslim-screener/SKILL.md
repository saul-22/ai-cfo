---
name: canslim-screener
description: Use when scoring a stock against the CANSLIM 7-criteria framework for growth stock screening. Typical use is in quarterly scans or when evaluating a new growth stock candidate before stock-audit.
---

# CANSLIM Screener

## Overview

CANSLIM 是 William O'Neil 提出的成长股筛选框架。7 个字母代表 7 个标准。

**职责边界：**
- 本 skill 只输出评分，不做买卖决定
- 评分结果输入 `stock-audit` 做进一步验证
- 不替代 `stock-audit`，不替代 `monthly-portfolio-plan`

## 7 标准

| 字母 | 标准 | 门槛 | FMP 数据源 |
|------|------|------|-----------|
| **C** | Current Quarterly Earnings | 最近一季 EPS 同比增长 ≥25% | `/income-statement?period=quarter` |
| **A** | Annual Earnings Growth | 年度 EPS 连续 3 年增长 ≥25% | `/income-statement?period=annual` |
| **N** | New (新产品/新管理/新高)| 股价接近或突破 52 周高点 | `/quote` 的 yearHigh |
| **S** | Supply & Demand | 市值合理 + 日均成交量足 | `/quote` 的 marketCap、volume |
| **L** | Leader or Laggard | 行业内 RS 排名（相对强度）≥80 | 需对比同行业，手算 |
| **I** | Institutional Sponsorship | 机构持股比例上升 | `/institutional-ownership` |
| **M** | Market Direction | 大盘趋势向上 | SPY 50/200 日均线 |

## 评分规则

每个字母评 0-10 分，总分 70 分满分。

| 单字母得分 | 判定 |
|-----------|------|
| 8-10 | ✅ 达标 |
| 5-7 | ⚠️ 勉强 |
| 0-4 | ❌ 未达标 |

**总分判定：**
| 总分 | 判定 | 动作 |
|------|------|------|
| 56-70 | ✅ PASS | 进入 stock-audit 详审 |
| 35-55 | ⚠️ CONDITIONAL | 关注但不买 |
| < 35 | ❌ FAIL | 淘汰 |

**硬淘汰条件（任一触发即 FAIL，不看总分）：**
- C < 5（最近一季 EPS 同比增长 < 15%）
- A < 5（年度 EPS 增长不稳定）
- M < 5（大盘熊市 —— SPY 跌破 200 日均线）

## Workflow

### 1. 确认输入

用户提供：股票代码（可多只）。

### 2. 拉数据（见 skills/_shared/fmp-client.md）

**数据源策略（YYYY-MM-DD 实测）：**
- FMP 免费版覆盖：部分大盘股（如 SPY 及多数美股蓝筹）→ 用 `/stable/*` 端点
- FMP 免费版不覆盖：多数 ETF 和 Premium 锁定的标的 → WebSearch 兜底

**端点（对 FMP 覆盖的 symbol）：**
- `/stable/quote?symbol=XXX` — 价格、52 周高/低、成交量、市值
- `/stable/income-statement?symbol=XXX` — 季度/年度 EPS、营收
- `/stable/key-metrics-ttm?symbol=XXX` — PE、EV/Sales、ROE、FCF Yield
- `/stable/ratios-ttm?symbol=XXX` — 毛利率、营业利润率、净利率
- `/stable/profile?symbol=XXX` — sector、industry（L 字母算 RS 用）
- `/stable/quote?symbol=SPY` — 大盘方向（M 字母）

**对 WebSearch 兜底的 symbol：**
每个字母的数据都要分别搜（Q/A 搜"季度 EPS 同比"、I 搜"机构持仓"等）。准确度降低。

**在最终输出中标注数据源：**
```
| 字母 | 得分 | 数据源 |
|------|------|--------|
| C | 10/10 | FMP (income-statement, FMP 覆盖时) |
| C | 6/10 | WebSearch (搜索结果不全，置信度中等) |
```

### 3. 计算每个字母

**C（最近一季 EPS 同比）：**
```
最近一季 EPS - 去年同期 EPS
_________________________
    去年同期 EPS
```
如某股最新一季 EPS $1.62 vs 去年同期 EPS $0.80 → 增长 102.5% → C = 10

**A（年度 EPS 3 年 CAGR）：**
```
(最新年度 EPS / 3 年前年度 EPS)^(1/3) - 1
```
≥ 25% 为 10 分；20-25% 为 7 分；15-20% 为 5 分；< 15% 为 0-3 分

**N（价格相对 52 周高）：**
```
(当前价 / 52周高) × 10
```
0.95+ = 10；0.85-0.95 = 7；< 0.85 = 3

**S（市值 + 流动性）：**
市值 > $10B 且日均成交量 > 1M → 10
市值 > $1B 且成交量 > 500K → 7
其他 → 低分

**L（行业 RS 排名）：**
对比同行业 3-5 个竞品近 12 个月涨幅，当前股在分位：
- 前 20% → 10
- 20-40% → 7
- 40-60% → 5
- < 60% → 低分

**I（机构持仓变化）：**
本季 vs 上季机构持股比例：
- 上升 → 8-10
- 持平 → 5
- 下降 → 0-3

**M（大盘方向）：**
- SPY 在 200 日均线之上 + 50 日均线向上 → 10
- SPY 在 200 日均线之上但 50 日向下 → 6
- SPY 跌破 200 日均线 → 3（组合考虑暂停激进仓位）

### 4. 输出格式

```markdown
## CANSLIM 评分：[TICKER]

**总分：** XX/70 ｜ 判定：✅/⚠️/❌

| 字母 | 指标 | 数值 | 得分 | 备注 |
|------|------|------|------|------|
| C | 季度 EPS 同比 | +X% | X/10 | |
| A | 年度 EPS CAGR | X% | X/10 | |
| N | 价/52W 高 | X% | X/10 | |
| S | 市值 + 成交量 | $XX B | X/10 | |
| L | 行业 RS 分位 | 前 X% | X/10 | 对比 [竞品] |
| I | 机构持股变化 | ↑/↓ X% | X/10 | |
| M | 大盘方向 | [趋势] | X/10 | SPY vs 200 日线 |

### 硬淘汰检查
- C < 5：[是/否]
- A < 5：[是/否]
- M < 5：[是/否]

### 结论
[2-3 句话总结 + 下一步建议]
```

### 5. 记录到 scan-history

批量评分（季度扫描时）：在 `investment/records/scan-history.md` 的对应季度段落追加一个 CANSLIM 汇总表。

单只评分（临时评估）：输出给用户即可，不写入文件。

## When to Use

**用：**
- "给 [TICKER] 打 CANSLIM 分"
- "季度扫描时批量筛选"
- 加新候选股到 dossier 前的第一步筛选

**不用：**
- 月度定投执行（不需要）
- 持仓已买了的重评估（用 stock-audit）
- 大盘择时（CANSLIM 不择时）

## Integration

```
us-stock-scanner → 候选池 → canslim-screener → stock-audit → 通过才进 portfolio-config
```

## Important Rules

1. **只评分，不建议**：输出分数和判定，不说"建议买入"
2. **硬淘汰优先**：C/A/M 任一 < 5 直接 FAIL
3. **数据源**：只用 FMP，不用 WebSearch 拼凑（数据一致性）
4. **缓存**：同一天对同一只股票评分用缓存结果，减少 API 消耗

## 版本

- 版本：1.0
- 创建：YYYY-MM-DD
- 依赖：FMP API（skills/_shared/fmp-client.md）、stock-audit（下游）
