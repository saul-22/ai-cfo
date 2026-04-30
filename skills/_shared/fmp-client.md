---
name: fmp-client
description: Financial Modeling Prep (FMP) API 共用客户端规范。所有需要结构化金融数据的 skill 都应通过此规范调用 FMP，不能覆盖的持仓回退到 WebSearch。
---

# FMP API 共用客户端规范

## 为什么存在

项目之前拉数据全靠 `WebSearch`，问题：
- 每次需要 5-6 次独立搜索才凑齐 6 只持仓的价格
- 返回的是非结构化文本，容易解析错
- 速度慢，季度扫描一次要 10+ 分钟

FMP API 提供结构化金融数据（免费版 250 请求/天 + 500 MB 流量/30 天）。**免费版对部分持仓有覆盖限制**（见下表），其余用 WebSearch 兜底。

## ⚠️ YYYY-MM-DD 验证过的免费版覆盖情况

**重要：** FMP 从 2025-08-31 起把 `/api/v3/*` 设为 Legacy，免费版用户必须用 `/stable/*` 端点。

### 持仓覆盖（已实测，举例）

| 持仓 | FMP 免费版 | 兜底方案 |
|------|-----------|---------|
| 大多数美股蓝筹个股 | ✅ 全端点可用 | — |
| SPY | ✅ 全端点可用（大盘参考）| — |
| 多数 ETF（含宽基 ETF）| ❌ Premium 锁定 | WebSearch |
| 部分个股（如制药/小盘） | ❌ Premium 锁定 | WebSearch |

**覆盖率因持仓而异。** 若需全覆盖，Starter 计划（$14-19/月）可覆盖全部。

## API Key 管理

**Key 位置：** `./.env.local`

**格式：**
```
FMP_API_KEY=<你的key>
```

**安全：**
- `.env.local` 已在 `.gitignore` 排除，永不入库
- 权限 600（`chmod 600 .env.local`），只有用户能读
- 永不在 commit message、聊天、日志中出现 key 的值
- skill 每次读 key 时都从 `.env.local` 读，不硬编码

**读 key（Bash）：**
```bash
source ./.env.local
# 现在 $FMP_API_KEY 可用
```

## Stable 端点清单（已实测免费版可用）

所有端点基础 URL：`https://financialmodelingprep.com/stable/`
参数格式：`?symbol=XXX&apikey=$FMP_API_KEY`（query parameter，不是 path）

### 1. 实时报价 `/stable/quote`
```bash
curl "https://financialmodelingprep.com/stable/quote?symbol=AAPL&apikey=$FMP_API_KEY"
```
返回字段：`price`、`changePercentage`、`change`、`volume`、`dayLow`、`dayHigh`、`yearHigh`、`yearLow`、`marketCap`、`priceAvg50`、`priceAvg200`、`previousClose`、`timestamp`

### 2. 公司概况 `/stable/profile`
```bash
curl "https://financialmodelingprep.com/stable/profile?symbol=AAPL&apikey=$FMP_API_KEY"
```
含：`marketCap`、`beta`、`lastDividend`、`range`（52W 高低）、`sector`、`industry`、`description` 等。

### 3. 历史价（轻量版）`/stable/historical-price-eod/light`
```bash
curl "https://financialmodelingprep.com/stable/historical-price-eod/light?symbol=AAPL&apikey=$FMP_API_KEY"
```
返回近期每日 `date`、`price`、`volume`。用于回撤、趋势、相关性。

### 4. 利润表 `/stable/income-statement`
```bash
curl "https://financialmodelingprep.com/stable/income-statement?symbol=AAPL&apikey=$FMP_API_KEY"
# 可加 period=quarter 拿季度数据
```
CANSLIM 的 C/A 字母要用它（EPS 季度/年度增长）。

### 5. TTM 关键指标 `/stable/key-metrics-ttm`
```bash
curl "https://financialmodelingprep.com/stable/key-metrics-ttm?symbol=AAPL&apikey=$FMP_API_KEY"
```
含：`marketCap`、`enterpriseValueTTM`、`evToSalesTTM`、`evToOperatingCashFlowTTM`、`returnOnEquityTTM`、`freeCashFlowYieldTTM` 等。

### 6. TTM 财务比率 `/stable/ratios-ttm`
```bash
curl "https://financialmodelingprep.com/stable/ratios-ttm?symbol=AAPL&apikey=$FMP_API_KEY"
```
含：`grossProfitMarginTTM`、`ebitMarginTTM`、`ebitdaMarginTTM`、`operatingProfitMarginTTM`、`netProfitMarginTTM`、`returnOnAssetsTTM` 等。

### 7. 个股财报日期 `/stable/earnings`
```bash
curl "https://financialmodelingprep.com/stable/earnings?symbol=AAPL&apikey=$FMP_API_KEY"
```
返回：下次财报日期、EPS 预期、营收预期。

### 8. 全市场财报日历 `/stable/earnings-calendar`
```bash
curl "https://financialmodelingprep.com/stable/earnings-calendar?from=YYYY-MM-DD&to=YYYY-MM-DD&apikey=$FMP_API_KEY"
```
返回时间段内全市场财报公告。过滤持仓用：
```bash
| jq '[.[] | select(.symbol | IN("AAPL","GOOGL"))]'
```

## 混合数据源规范

**原则：能用 FMP 就用 FMP，不能用的用 WebSearch。**

### 标准流程

```bash
# 1. 先尝试 FMP（只对白名单持仓）
FMP_COVERED="<TICKER> <TICKER> <TICKER> SPY"
WEBSEARCH_NEEDED="<TICKER> <TICKER> <TICKER>"

# 2. 并行：FMP 一次批量 + WebSearch 分别查
# （WebSearch 是 Claude 工具，需要分别触发每个 ticker）

# 3. 合并结果，在输出中注明数据源
```

### 输出标注

每次展示价格/数据时必须注明：

| 代码 | 价格 | 数据源 | 时间戳 |
|------|------|-------|--------|
| <TICKER> | $XXX.XX | FMP | YYYY-MM-DD |
| <TICKER> | $XXX.XX | WebSearch | YYYY-MM-DD |

让用户知道哪些是实时结构化、哪些是搜索得到的。

## 请求预算

**免费版：**
- 250 请求/天
- 500 MB 流量/30 天

**典型消耗（混合方案）：**
| 场景 | FMP 消耗 | WebSearch 消耗 |
|------|---------|---------------|
| 每日价格刷新 | N（FMP 覆盖的持仓数）| M（WebSearch 兜底数）|
| 周风控 | 4 | 3 |
| 月度风控 | 8-10 | 3 |
| 季度扫描（持仓）| 20-30 | 6-10 |
| 季度扫描（候选池 30 只，优先筛 FMP 支持的）| 60-90 | 按需 |

日均 30-50 FMP 请求，远低于 250 上限。

## 降级策略

如果 FMP 出现以下任一，整体回退到 WebSearch：
- 连续 3 次 401（key 失效）
- 连续 3 次 429（限流）
- 流量月用完
- 网络不通

降级时在 Claude 输出中明确：「FMP 暂不可用，本次全部 WebSearch 兜底，数据结构化程度降低」。

## 常用工具

### jq 解析 JSON
macOS 默认安装了 Python 3，优先用 Python 处理 JSON：
```bash
... | python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['price'])"
```

### 格式化输出
持仓快照标准格式（Python 一行）：
```python
print(f"{sym:<6}${price:>9.2f}{change_pct:>+9.2f}%PE={pe:>6.1f}")
```

## 不做的事

- 不用 legacy API 端点（2025-08-31 已 Legacy，免费版不可用）
- 不硬编码 key 到任何 git 追踪文件
- 不把 key 作为 bash history 留存（用 `source` 而不是 `export FMP_API_KEY=XXX`）
- 不对 Premium 锁定的 symbol 重复请求（白名单之外直接 WebSearch）
- 不写 Python SDK（Claude 直接 curl + python3 处理即可）

## 版本

- 版本：2.0（YYYY-MM-DD 重写，适配 FMP stable 端点）
- 创建：YYYY-MM-DD
- 维护者：Claude
- 依赖：FMP API stable、curl、python3

## 更新记录

| 日期 | 变更 |
|------|------|
| YYYY-MM-DD | v1.0 创建（基于 v<N> 端点，未实测）|
| YYYY-MM-DD | v2.0 重写：v<N> 已 Legacy，改用 stable；实测确认部分蓝筹/SPY 可用，多数 ETF 需 WebSearch 兜底 |
