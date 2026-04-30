# tradermonty/claude-trading-skills（精选 5 个）

**来源：** https://github.com/tradermonty/claude-trading-skills
**引入日期：** 2026-04-23
**审计：** 通过

## 选了哪些（从 50+ 个精选）

| Skill | 大小 | 用途 | FMP 免费版 |
|---|---|---|---|
| macro-regime-detector | 4 KB + 16 KB refs | 6 component 宏观 regime（5 类）| ⚠️ 方法论可用，script 需 Starter |
| market-top-detector | 8 KB | 市场顶部概率 0-100（O'Neil + Minervini + 防御轮动）| ⚠️ 同上 |
| us-market-bubble-detector | 19 KB | 泡沫风险 Minsky/Kindleberger v2.1 | WebSearch 可跑 |
| scenario-analyzer | 12 KB | 情景分析 + 压力测试 | WebSearch 可跑 |
| position-sizer | 6 KB | ATR / Kelly / Fixed Fractional 仓位计算 | FMP 部分可用 |

未来可选拉的（暂不需要）：
- market-top-detector（市场顶部预警）
- us-market-bubble-detector（泡沫检测）
- sector-analyst（板块分析）
- economic-calendar-fetcher（经济日历）
- breadth-chart-analyst（市场宽度）

## macro-regime-detector 改造说明

**原版能力：**
- Python script 拉 9 个 ETF + Treasury rates（10 FMP API calls）
- 自动算 6 个 component 的比率
- 输出 5 种 regime 分类 + 投资姿态建议

**FMP 免费版限制（实测 2026-04-23）：**
- 8 个 ETF 中只有 SPY 可用
- RSP / HYG / LQD / IWM / TLT / XLY / XLP **全部 Premium 锁定**
- Python script **跑不起来**

**我们的用法（混合）：**
1. **方法论可用：** 6 component 的定义 + 5 regime 分类 + 历史例子（references/ 三个文档）作为知识储备
2. **WebSearch 兜底：** 每周日跑"周风控"时，用 WebSearch 拉 7 个 ETF 当前价 + 1 周前价，手算关键比率
3. **何时启用 Python：** 未来升级 FMP Starter 计划（$14-19/月）后，直接跑 script

**周风控时手算的简化版：**

```
最关键 4 个比率（不需要全部 6 个）：
1. RSP/SPY ratio — 大盘宽度（< 10Y avg = 集中型市场）
2. 10Y-2Y spread — 收益率曲线（< 0 = 倒挂预警衰退）
3. SPY/TLT ratio — 股债关系
4. XLY/XLP ratio — 风险偏好（消费 vs 防御）

每个 1-2 次 WebSearch（拉两个时点）= 总共 8-10 次 search ≈ 5 分钟
```

**不装 script 的代价：**
- 5 种 regime 自动分类不可用，需 Claude 看比率手动判
- 历史回测对比不可用
- 但**核心信号**（曲线倒挂、信用紧张）仍能感知

**下次升级时机：** 资产 > 50 万人民币 或 单次失误成本 > FMP Starter 一年订阅费时考虑。

## 安全审计

✅ 通过：
- SKILL.md 是标准 Claude skill 格式
- 无危险指令（rm/curl shell/敏感路径）
- references/ 全部为方法论文档
- 仅依赖 FMP API（已配）+ Python（macOS 原生）
- 输出 JSON + Markdown，无外部上传

## 触发关键字

- "宏观 regime" / "市场状态" / "美林时钟" → 加载 SKILL.md 方法论
- "周风控" → 触发 scan-history 周风控段（含简化 macro 快照）
