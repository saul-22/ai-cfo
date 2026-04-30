---
name: fscore-screener
description: Score a stock with the Piotroski F-Score (9-criteria financial health score). Use when assessing balance-sheet strength of a candidate stock, complementing CANSLIM (growth) and Graham (value) filters in multi-framework screening.
---

# Piotroski F-Score Screener

## 为什么自己写

调研后无现成 Claude skill 实现 Piotroski F-Score。逻辑明确（9 个 binary 信号），自己写比装第三方更轻量、更可控、贴合本项目。

**理论来源：** Joseph D. Piotroski (2000), "Value Investing: The Use of Historical Financial Statement Information to Separate Winners from Losers from Losers." 在原研究 20 年回测中，高 F-Score（8-9）股票年化跑赢市场 13.4%。

## 9 个评分项（每项 1 或 0 分，总分 0-9）

### 盈利能力（4 项）
| # | 项 | 标准 | 1 分条件 |
|---|---|---|---|
| 1 | 净利润 | 当年净利润为正 | NI > 0 |
| 2 | 经营现金流 | 当年经营现金流为正 | CFO > 0 |
| 3 | ROA 改善 | ROA 同比增长 | ROA(t) > ROA(t-1) |
| 4 | 盈利质量 | 现金流 > 净利润（无应计欺诈嫌疑）| CFO > NI |

### 杠杆/流动性（3 项）
| # | 项 | 标准 | 1 分条件 |
|---|---|---|---|
| 5 | 杠杆下降 | 长期债务/总资产 同比下降 | LTD/TA(t) < LTD/TA(t-1) |
| 6 | 流动比改善 | 流动资产/流动负债 同比上升 | CR(t) > CR(t-1) |
| 7 | 不稀释股本 | 当年未发行新股 | Shares(t) ≤ Shares(t-1) |

### 运营效率（2 项）
| # | 项 | 标准 | 1 分条件 |
|---|---|---|---|
| 8 | 毛利率改善 | 毛利率同比上升 | GM(t) > GM(t-1) |
| 9 | 资产周转率改善 | 营收/总资产 同比上升 | AT(t) > AT(t-1) |

## 评分判定

| 总分 | 判定 | 含义 |
|------|------|------|
| 8-9 | ✅ 强 | 财务非常健康，Piotroski 推荐买入候选 |
| 5-7 | ⚠️ 中 | 健康但有改善空间，结合其他 filter 看 |
| 4 | ⚠️ 临界 | 价值陷阱风险升高 |
| 0-3 | ❌ 弱 | Piotroski 推荐避开或做空 |

## 数据需求

每只股票需要近 2 年数据：
- 利润表：净利润、营收、毛利
- 现金流量表：经营现金流
- 资产负债表：总资产、长期债务、流动资产、流动负债、流通股本

## 数据源策略（混合）

**FMP 覆盖的 symbol（多数大盘股 + SPY）：**
```bash
source ./.env.local
curl -s "https://financialmodelingprep.com/stable/income-statement?symbol=$SYM&apikey=$FMP_API_KEY" | python3 -c "..."
curl -s "https://financialmodelingprep.com/stable/balance-sheet-statement?symbol=$SYM&apikey=$FMP_API_KEY" | python3 -c "..."
curl -s "https://financialmodelingprep.com/stable/cash-flow-statement?symbol=$SYM&apikey=$FMP_API_KEY" | python3 -c "..."
```

**FMP 不覆盖的（多数 ETF / Premium 锁定）：** WebSearch 兜底
- 搜 "[ticker] Piotroski F-Score YYYY" 看现成评分
- 或搜 "[ticker] balance sheet YYYY YYYY" 手动算

**ETF：** F-Score 不适用 ETF，**仅用于个股**。

## 计算流程

### Step 1: 拉数据

最近 2 年（FY t 和 FY t-1）的：
- NI, CFO, Total Assets, LTD, Current Assets, Current Liabilities, Shares Out, Revenue, Gross Profit

### Step 2: 计算衍生指标

```
ROA(t)   = NI(t) / Total Assets(t)
ROA(t-1) = NI(t-1) / Total Assets(t-1)
CR(t)    = CA(t) / CL(t)
GM(t)    = GP(t) / Rev(t)
AT(t)    = Rev(t) / Total Assets(t)
```

### Step 3: 9 项打分

按上面 9 项标准，每项 1 或 0 分。

### Step 4: 输出

```markdown
## F-Score: [TICKER]

**总分：** X/9 ｜ 判定：✅/⚠️/❌

### 盈利能力（X/4）
| 项 | 数值 | 得分 |
|---|---|---|
| 1. 净利润 > 0 | $X | 1/0 |
| 2. CFO > 0 | $X | 1/0 |
| 3. ROA 改善 | X% → Y% | 1/0 |
| 4. CFO > NI | $X vs $Y | 1/0 |

### 杠杆/流动性（X/3）
（同上格式）

### 运营效率（X/2）
（同上格式）

### 解读
[2-3 句话]

### 数据来源
- FMP / WebSearch
- 数据时点：FY t = ..., FY t-1 = ...
```

## 触发关键字

- "F-Score X" / "Piotroski X" → 单只评分
- 季度扫描时批量评候选池

## 与其他 filter 的关系

```
候选股
  ├→ CANSLIM       — 成长动能
  ├→ Graham        — 估值安全
  ├→ Buffett 五问  — 护城河
  ├→ Lynch PEG     — 增长合理价
  ├→ F-Score       — 财务健康（本 skill）
  ├→ DCF           — 内在价值
  └→ 13F           — 机构信号

  → 至少 4 个 PASS 才进入组合
  → 大仓位（>10%）需 6 个 PASS
```

F-Score 是**基础门槛**类——分数低（< 5）几乎是 deal-breaker，无论 CANSLIM 多漂亮。

## 限制

- ETF 不适用
- 金融行业（银行、保险）的某些项不适用（杠杆和现金流定义不同）
- 早期成长股可能 F-Score 低但仍有投资价值（CFO 暂时为负）
- 仅用财报数据，不反映即时市场变化

## 不做的事

- 不替代估值（F-Score 不告诉你"该买多少钱"）
- 不替代护城河分析（F-Score 不评估 competitive advantage）
- 不做时间序列预测（只看当年 vs 去年）

## 版本

- 版本：1.0
- 创建：YYYY-MM-DD
- 维护者：Claude（自写）
- 数据源：FMP stable + WebSearch 兜底
