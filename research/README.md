# 研究工作台

> 策略研究、宏观观察、单股深度分析的"草稿间"。
> 与 `investment/` 执行目录分离：执行目录是真相源，研究目录是探索区。

## 目录结构

| 目录 | 用途 | 更新频率 |
|------|------|---------|
| `quarterly-scans/` | 季度扫描的原始笔记、候选池、CANSLIM 批量评分、13F 汇总 | 每季度 |
| `stock-dossiers/` | 单股深度档案。当前持仓 + 观察名单 | 季度扫描时刷新，日常临时补充 |
| `macro-notes/` | 宏观观察（联储、关税、大宗、地缘、PCE、CPI）| 月度或事件驱动 |
| `theory-refs/` | 投资理论参考（CANSLIM 原著摘录、O'Neil、Graham、Buffett 致股东信要点）| 按需积累 |

## 为什么分离

研究是探索性、多轮、可能走弯路的工作。如果直接写在 `investment/records/scan-history.md`，会把：
- 真相源污染（投资决策文件变成研究日记）
- 归档混乱（半成品和最终结论纠缠）
- 未来 AI 理解错乱（读 scan-history 时把草稿当结论）

**分离后：**
- `research/` — 思考过程、候选、实验
- `investment/records/scan-history.md` — 只写最终结论
- 两者通过 commit message 交叉引用

## 工作流

### 季度扫描（8/1、11/1、2/1）

1. 在 `research/quarterly-scans/YYYYQn/` 建当季目录
2. 跑 us-stock-scanner + canslim-screener + institutional-flow-tracker
3. 原始评分数据、候选池、对比表都写在这里
4. 最终结论（换不换股、换哪个）写到 `investment/records/scan-history.md`
5. commit message 引用研究笔记路径

### 持仓单股跟踪

`stock-dossiers/` 下每只持仓一个文件（`<TICKER>.md`）。包含：
- 公司概况、行业地位
- 过去 4-8 季度 EPS / 营收 / FCF
- 最近 13F 机构动向
- 重大新闻时间线
- 为什么在组合里的"持股理由"
- 退出条件

季度更新，紧急事件临时补充。

### 宏观观察

`macro-notes/` 按月份组织：
```
macro-notes/
├── YYYY-MM-topic-a.md
├── YYYY-MM-topic-b.md
└── ...
```

不强制每月写，重大事件时写。作为决策时的历史背景。

### 理论参考

`theory-refs/` 放精华摘录，不是整本书。写得像备忘，以后查时秒懂。

## 不做的事

- 不在这里记账（那是 investment/records/investment-ledger.md 的事）
- 不在这里更新持仓数据（那是 holding-summary.md 的事）
- 不写日记（这是工作台不是日记本）
- 不重复 `investment/` 里已有的内容

## Git

本目录完整纳入 Git，和 `investment/` 一起版本化。研究笔记越老越有价值（可以回看"当时我以为..."）。
