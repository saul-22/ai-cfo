---
name: institutional-flow-tracker
description: Use when checking institutional (13F) ownership changes for any held or candidate stock. Typical use is in quarterly scans or when auditing if big money is accumulating or exiting a position before stock-audit.
---

# Institutional Flow Tracker (13F)

## Overview

13F 是美国 SEC 要求管理资产 >$1 亿的机构投资人每季度披露持仓的文件。跟踪 13F 变化能看出：
- 哪些大基金在买/卖某只股票
- 整体机构持股比例是在上升（看多）还是下降（看空）
- 重仓 basket 的变化（对比 Warren Buffett、ARK、Tiger Global 等）

**本 skill 职责：**
- 只拉数据 + 摘要变化，不推断因果
- 不建议买卖
- 结果输入 `canslim-screener` 的 I 字母 + `stock-audit` 的 Overlap & Concentration 维度

**本 skill 不做：**
- 不跟踪内部人（insider）交易（需另一个 skill）
- 不跟踪 ETF 资金流
- 不跟踪零售（Robinhood 等）情绪

## 数据限制

- 13F **滞后** 45 天：Q4 数据 2/15 才出、Q1 数据 5/15 才出
- 用来做长期判断（3-6 个月视角），不适合月内决策
- 免费版 FMP 只能拿最近 8 季度

## Workflow

### 1. 确认输入

用户提供：
- 股票代码（必填）
- 参考季度（可选，默认最近）
- 对比深度（可选，默认 4 季度）

### 2. 拉数据

**数据源策略（YYYY-MM-DD 实测）：**
- FMP 免费版 institutional endpoint 对部分持仓可用
- 对 Premium 锁定的 symbol，用 WebSearch 查"[ticker] 13F institutional ownership latest quarter"兜底

**FMP 端点（对支持的 symbol）：**
```bash
# 机构持仓汇总（注意端点可能需实测确认路径）
curl "https://financialmodelingprep.com/stable/institutional-ownership?symbol={SYMBOL}&apikey=$FMP_API_KEY"

# 若 stable 不支持，fallback 到 WebSearch
```

**WebSearch 兜底查询模板：**
- "[ticker] 13F filings Q1 2026 institutional ownership change"
- "[ticker] top institutional holders"
- "whalewisdom [ticker]"（whalewisdom.com 是公开 13F 聚合）

返回字段（关键）：
- `investorsHolding` — 持有机构数
- `totalInvested` — 机构总持仓金额
- `ownershipPercent` — 机构持股比例
- `changeInSharesHeld` — 环比股数变化
- `changeInInvestmentValue` — 环比金额变化

### 3. 查知名机构动向（可选加分项）

```bash
# 某机构的 13F 持仓
curl "https://financialmodelingprep.com/api/v3/form-thirteen/{CIK}?date={YYYY-MM-DD}&apikey=$KEY"
```

常用机构 CIK（预填）：
- Berkshire Hathaway（Warren Buffett）：0001067983
- Tiger Global Management：0001167483
- ARK Investment：0001697748
- Citadel Advisors：0001423053
- Renaissance Technologies：0001037389

### 4. 对比分析

对每只股票算：

| 指标 | 计算 | 解读 |
|------|------|------|
| 持有机构数变化 | Q vs Q-1 | +5% 看多 / -5% 看空 |
| 机构持股比例 | 当前 % | >50% 高度机构化 / <20% 散户主导 |
| 大基金动向 | 重点 5-10 家持仓变化 | 重仓增加 = 正信号 |
| 主力连续动向 | 最近 2-3 季度趋势 | 连续买入 = 强信号 |

### 5. 输出格式

```markdown
## 13F 机构持仓追踪：[TICKER]

**参考季度：** YYYYQn（披露日 YYYY-MM-DD）
**时效性：** 数据滞后 ~45 天

### 整体概览
- 持有机构数：XXX 家（上季度 XXX，环比 ±X%）
- 机构持股比例：XX.X%（上季度 XX.X%，环比 ±X.X pp）
- 总持仓金额：$XX B（上季度 $XX B）

### 近 4 季度趋势
| 季度 | 机构数 | 持股比例 | 持仓金额 |
|------|-------|---------|---------|
| YYYYQn | | | |
| YYYYQn-1 | | | |
| YYYYQn-2 | | | |
| YYYYQn-3 | | | |

### 主力机构动向（Top 10）
| 排名 | 机构 | 本季持仓 | 环比变化 | 占机构总持仓 % |
|------|------|---------|---------|--------------|
| 1 | ... | ... | +X% / -X% | ... |

### 判定
- 整体方向：[机构累积 / 机构减持 / 持平]
- 信号强度：[强 / 中 / 弱]
- CANSLIM I 字母建议评分：X/10

### 限制说明
- 数据截至 YYYY-MM-DD，距今 XX 天
- 不包含 13F 豁免的私募 / 对冲基金
- 仅披露多头，空头未强制披露
```

### 6. 记录（如需）

- 季度扫描时：写入 `research/quarterly-scans/YYYYQn-13f-summary.md`
- 单只追踪：用户查询后输出即可，不写文件
- 持仓股票季度变化：每季度扫描时更新 `research/stock-dossiers/{SYMBOL}.md` 的 13F 区块

## When to Use

**用：**
- "查一下 [TICKER] 的机构持仓变化"
- 季度扫描批量查当前持仓
- 候选股进入 CANSLIM 评分前的 I 字母

**不用：**
- 月度执行（数据粒度太粗）
- 日度/周度（13F 只季度更新）
- 大盘判断（用 SPY 均线即可）

## Integration

```
季度扫描 (us-stock-scanner)
    → 13F 数据 (本 skill)
    → CANSLIM I 字母 (canslim-screener)
    → 综合评分 (stock-audit)
```

## Important Rules

1. **时效性声明**：每次输出明确标注数据截至日期 + 距今天数
2. **不推测动机**：只报数据，不说"巴菲特要买"（可能已反手卖了）
3. **对齐 canslim**：I 字母评分标准与 canslim-screener 保持一致
4. **缓存**：13F 数据 45 天滞后，同一季度数据缓存整季，不重复拉

## 版本

- 版本：1.0
- 创建：YYYY-MM-DD
- 依赖：FMP API、canslim-screener（下游）、stock-audit（下游）
