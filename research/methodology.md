# 投资方法论

> 本项目的投资方法论锚点文档。
> 对照资深投资经理（professional PM）完整流程，形成我们项目的 10 步框架 + 差距 + 演进路径。
> 修改者：Claude（决策者）。最后更新：YYYY-MM-DD。

---

## 为什么存在

现状诊断：我们目前的流程是"临时扫描 → 单一框架筛（CANSLIM）→ 启发式配权 → 不做归因"，属于**拼凑式**而非**系统化**。

资深经理选组合有清晰的 10 步 framework，每步输出明确物料，下一步用上一步的输出。我们对照这个 framework 找差距，分阶段补齐。

**这份文档的用途：**
- 每次换股 / 季度扫描 / 年度再平衡前对照此方法论执行
- 新手续员（未来的 Claude 版本 / 外部顾问）看一份文档理解全流程
- 是 portfolio-config.txt（规则）、buy-order.txt（执行）、records/decision-journal.md（思考）的**上游理论基础**

---

## 🔒 架构铁律：策略线与执行线严格分离

**10 步方法论在项目里分成两条独立的"流水线"：**

```
根目录
═══════
ips.md（宪法，约束两条线）

策略线（research/）                       执行线（investment/）
═══════════════════                      ═══════════════════
2. 宏观 Regime                            
3. SAA 资产配置                           
4. 行业主题                               
5. 候选池                                 
6. 多框架评分                             
7. 数学化组合构建                         
        ↓                                 
   生成提案                               
   research/proposals/*.md                
        ↓ 用户审批                        
        └──────────→  8. 风险规则更新
                      9. 执行（DCA / 成交）
                      10. 监控（归因 + benchmark）
```

**关键分界：**
- IPS（步骤 1）在根目录，是两条线共同的顶层约束
- 步骤 2-7 全部在策略线（research/），不碰 `investment/`
- 步骤 8-10 全部在执行线（investment/），只读最新 `portfolio-config.txt` + 已归档提案
- **唯一通道：** 策略线产出提案 → 用户审批 → 执行线应用变更

详见 `research/proposals/README.md` 和 `CLAUDE.md` 的"策略-执行隔离规则"。

---

## 10 步专业方法论

### 1. Investment Policy Statement (IPS) — 投资政策声明

**做什么：** 形式化组合的"宪法"，所有后续决策都以 IPS 为约束。

**8 项标准内容：**
| 项 | 含义 | 我们的内容 |
|---|---|---|
| 目标 | 数字化终极目标 | 15-20 年累计 1000 万 |
| 风险容忍度 | 最大可接受回撤 | -23%（当前版本模拟值）|
| 流动性需求 | 何时需要提取 | **待补** |
| 时间 Horizon | 投资期限 | 15-20 年 |
| 税务 | 税务身份和优化 | 中国居民 / W-8BEN / 非美居民资本利得免税 |
| 再平衡规则 | 什么条件重新配置 | ±5% 增量校正、±10% 年度再平衡 |
| Benchmark | 业绩对标 | **待补**（建议 SPY 或 70% SPY + 20% GLD + 10% BND）|
| 审查周期 | 定期 review 节奏 | 月/季/年 |

**理论来源：** CFA Institute《Private Wealth Management》。

**输出物：** 一份 IPS 文件（锚定所有下游决策）。

---

### 2. 宏观 Regime 判断 — Regime Classification

**做什么：** 定位当前经济周期阶段，决定风格倾斜方向。

**主流框架：**
- **美林时钟（Merrill Lynch Clock）**：按"经济增长 + 通胀"2×2 分四象限
  - 复苏：经济↑ + 通胀↓ → 股票（尤其周期）
  - 过热：经济↑ + 通胀↑ → 大宗 / 通胀受益股
  - 滞胀：经济↓ + 通胀↑ → 现金 / 黄金
  - 衰退：经济↓ + 通胀↓ → 债券
- **信号指标：** GDP、CPI、PMI、ISM、2Y/10Y 收益率曲线、HY 利差、VIX、失业率

**理论来源：** Merrill Lynch research、Ray Dalio《Principles for Navigating Big Debt Crises》、BCA Research 宏观框架。

**输出物：** 当前 regime 标签 + 持续预估 + 对组合的倾斜建议（如 "滞胀期 → 重黄金、减科技"）。

---

### 3. Strategic Asset Allocation (SAA) — 战略资产配置

**做什么：** 决定大类资产的长期目标权重（股 / 债 / 商 / 现金）。

**方法：**
- **风险平价（Risk Parity）**：每类资产贡献等量风险（而非等金额）
- **60/40 经典组合**：60% 股 / 40% 债
- **全天候组合（Dalio All Weather）**：30% 股 + 40% 长债 + 15% 中债 + 7.5% 商 + 7.5% 黄金
- **Life-Cycle**：随年龄增长降股票权重（100 - 年龄 = 股票比例）

**理论来源：** Markowitz《Portfolio Selection》1952、Dalio All Weather、Swensen《Pioneering Portfolio Management》。

**输出物：** 大类资产比例（我们的 40/30/20/10 层级）。

---

### 4. 主题 / 行业选择 — Thematic & Sector Tilts

**做什么：** 在 SAA 框架内决定重点行业 / 主题。

**维度：**
- **长期 secular trend**：AI、老龄化、能源转型、印度/东盟崛起
- **周期性 tilt**：Regime 决定（滞胀重能源和黄金、复苏重金融和消费）
- **估值 tilt**：历史估值分位（过去 10 年 P/E 分位 < 30% → 低估）

**理论来源：** Howard Marks《The Most Important Thing》、Peter Lynch《One Up on Wall Street》、Damodaran《The Dark Side of Valuation》。

**输出物：** 重点行业清单 + 权重倾斜（当前版本见 `investment/portfolio-versions.md`）。

---

### 5. 候选池构建 — Universe Construction

**做什么：** 从全市场（~5000 只）筛选到 Watchlist（~50-200 只）。

**两层 filter：**
- **第一层（hard filter）**：市值 > $10B、日均成交量 > 1M、上市 ≥ 3 年、非 penny stock、非壳公司
- **第二层（基本面门槛）**：近 3 年无亏损、毛利率 > 20%、D/E < 2、不做空

**数据源：** FMP stock-screener API、SEC EDGAR、Yahoo Finance screener。

**理论来源：** William O'Neil《How to Make Money in Stocks》（CANSLIM 的候选池概念）、Benjamin Graham 防御型投资者标准。

**输出物：** Watchlist（CSV / markdown 表）。

---

### 6. 多框架评分 — Multi-Factor Scoring（**选股核心**）

**做什么：** Watchlist 每只股票过多个 filter，通过 4+ 个才进入组合备选。

**8 个经典 filter（每个查不同维度）：**

| Filter | 提出者 | 核心标准 | 适用 |
|---|---|---|---|
| **CANSLIM** | William O'Neil | C/A/N/S/L/I/M 7 字母成长动能 | 成长股 |
| **Graham** | Benjamin Graham | PB < 1.5、PE < 15、D/E < 0.5、连续 10 年正利润、安全边际 | 价值股 |
| **Lynch PEG** | Peter Lynch | PEG < 1（1 是合理、<0.5 极低估）+ 6 类股分类 | 中速成长股 |
| **Buffett 五问** | Warren Buffett | 护城河持续？管理层诚信？ROE>15%连续？再投资率？我理解这生意吗？ | 长期持有 |
| **F-Score** | Joseph Piotroski | 9 项财务健康打分（盈利+杠杆+效率）| 财务筛查 |
| **DCF** | McKinsey / Damodaran | FCF 折现 + WACC + 终值 → 内在价值 vs 市价 | 大仓位必过 |
| **13F 机构** | SEC filings | 主力资金 QoQ 变化 + 大牌基金动向 | 信号验证 |
| **Munger 反向** | Charlie Munger | "如果买了，什么情况会让我亏大钱？" | 风险预判 |

**评分方法：**
- 每 filter 输出 PASS / CONDITIONAL / FAIL
- 至少 **4 个 PASS** 才进下一步
- 大仓位（> 10%）需 **6 个 PASS**

**理论来源：** 各 filter 的原著（Graham《聪明投资者》、Buffett 年报致股东信、O'Neil、Lynch、Piotroski 2000 年论文、Damodaran 教材）。

**输出物：** 候选股的评分矩阵（横：filter，竖：股票）。

---

### 7. 组合构建 — Portfolio Construction（**配权重**）

**做什么：** 从候选池（6）选出具体组合 + 数学化决定权重。

**数学方法：**
| 方法 | 原理 | 特点 |
|---|---|---|
| **Mean-Variance Optimization (MVO)** | Markowitz 1952，最大化 Sharpe | 对协方差敏感 |
| **Black-Litterman** | MVO + 主观观点 Bayesian 融合 | 实务更稳 |
| **Risk Parity** | 每只贡献等量风险 | 高波动股自动减仓 |
| **Minimum Variance** | 最小波动率 | 防守型 |
| **Kelly Criterion** | 期望收益 / 方差最优仓位 | 单股上限验证 |
| **Equal Weight** | 等权 | 启发式，避免过拟合 |

**约束（硬边界）：**
- 单股 ≤ 20%（穿透后）
- 单板块 ≤ 40%
- 持仓相关系数平均 < 0.7
- 现金 buffer ≥ 10%

**理论来源：** Markowitz 1952、Sharpe 1964、Black-Litterman 1990、Kelly 1956、Maillard/Roncalli risk parity。

**输出物：** 目标组合（代码 + 权重 + 数学验证）。

---

### 8. 风险管理 — Risk Management Overlay

**做什么：** 在组合之上叠加风险规则。

**内容：**
- **紧急触发器**：单股 -40%、SEC 调查、CEO 离职、大盘 -20%
- **尾部风险对冲**：Deep OTM put、VIX ETF、金矿股
- **VaR / CVaR 监控**：95%/99% 信心水平下的最大预期亏损
- **压力测试**：2008、2020、2022 情景模拟
- **相关性崩溃预警**：黑天鹅时资产同跌

**理论来源：** Taleb《Antifragile》《The Black Swan》、Hull《Risk Management》。

**输出物：** 风控规则表（已有 portfolio-config.txt 第三节）。

---

### 9. 执行 — Execution

**做什么：** 把"目标组合"落地为"实际持仓"。

**内容：**
- **DCA 节奏**：每月 / 每季
- **成本最优**：券商手续费、税、汇率
- **Tax-Loss Harvesting**：亏损股 30 天规则
- **执行偏差控制**：实际成交 vs 目标偏差 < 1%

**理论来源：** Kahneman 行为金融、Algorithmic Execution 相关研究。

**输出物：** 买入清单（已有 buy-order.txt）+ Ledger（已有 records/investment-ledger.md）。

---

### 10. 监控 + 归因 + 再平衡 — Monitoring & Attribution

**做什么：** 持续检视业绩，拆分 α vs β，触发再平衡。

**三类工作：**

**A. 业绩 vs Benchmark 对标**
- 选定 benchmark（SPY / 自定义）
- 月度 / 季度对比超额收益
- Tracking error 计算

**B. Brinson 归因模型**
把组合回报拆成三部分：
```
总回报 = 配置效应（板块对了）+ 选股效应（股票对了）+ 交互 + 货币
```

**C. 再平衡触发**
- 偏离 ±5% → 增量校正
- 偏离 ±10% → 年度重平衡

**理论来源：** Brinson/Hood/Beebower 1986、CFA curriculum Performance Attribution。

**输出物：** 季度 / 年度报告（展示 α vs β 拆解）。

---

## 我们现状 vs 10 步（差距诊断）

| 步骤 | 完成度 | 工具 |
|---|---|---|
| 1. IPS | ✅ 95% | `ips.md`（根目录，12 节完整）|
| 2. 宏观 Regime | ✅ 75% | tradermonty/macro-regime-detector 方法论 + WebSearch 兜底 |
| 3. SAA | ✅ 90% | joellewis/asset-allocation（MVO/BL/Risk Parity 可用）|
| 4. 行业 | ✅ 85% | 手动 + macro-regime-detector 板块信号 |
| 5. 候选池 | ✅ 70% | `research/stock-dossiers/watchlist.md`（9 只初始池）|
| 6. 多框架评分 | ✅ 85% | ancs21 10 persona + CANSLIM + F-Score + 13F = 8 filter |
| 7. 数学化组合构建 | ✅ 80% | joellewis/bet-sizing（Kelly）+ asset-allocation（MVO）|
| 8. 风险管理 | ✅ 90% | tradermonty/market-top-detector + bubble-detector + scenario-analyzer + joellewis/historical-risk |
| 9. 执行 | ✅ 95% | monthly-portfolio-plan + fmp-client |
| 10. 监控归因 | ✅ 80% | joellewis/performance-attribution + performance.md Benchmark 对标 |

**整体完成度：约 85%（按专业标准）**

---

## 剩余差距（实战验证后补齐）

| 项 | 差距 | 何时补 |
|---|---|---|
| 候选池深度 | watchlist 9 只初始池，需扩到 30-50 只 | Q3 8/1 首次季度扫描 |
| 宏观 regime 自动化 | FMP 免费版 ETF 覆盖不足，手算 4 比率 | 升级 FMP Starter 后 |
| 多框架实战校准 | 8 filter 阈值未经实战验证（如 Graham PE<15 对成长股过严）| Q3 扫描后根据结果调 |
| 归因精度 | 当前简版 Brinson，缺多期链接和因子归因 | 年度复盘时用 JoelLewis 完整版 |
| 数学化组合验证 | MVO/Kelly 工具已有，未对当前版本实际跑过 | 年度再平衡前 |

**这些不是"缺工具"，是"缺实战数据"。工具已全部就位，等 Q3 8/1 首次季度扫描跑一遍就能校准。**

---

## 理论来源（经典书单）

按优先级读：
1. Benjamin Graham《聪明投资者》— 价值投资圣经
2. Peter Lynch《One Up on Wall Street》— 实用选股
3. William O'Neil《How to Make Money in Stocks》— CANSLIM
4. Warren Buffett 致股东信（1957-至今）— 复利 + 品质
5. Howard Marks《The Most Important Thing》— 风险 + 周期
6. Aswath Damodaran《The Little Book of Valuation》— DCF
7. Nassim Taleb《Antifragile》— 尾部风险
8. CFA Institute curriculum — 系统性知识体系
9. Ray Dalio《Principles》《How the Economic Machine Works》— 宏观
10. Michael Mauboussin《More Than You Know》— 决策

---

## 更新规则

- 每季度扫描后修订（补实战经验）
- 每次重大换股后检视（流程是否跑通）
- 每年底全面 review（和实际结果对照）
- 修改时在下表追加一行

## 更新历史

| 日期 | 变更 |
|------|------|
| YYYY-MM-DD | 创建文件。定义 10 步 + 现状诊断 + 四大硬缺口 + 演进路径 |
