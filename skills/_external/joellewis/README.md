# JoelLewis/finance_skills（精选）

**来源：** https://github.com/JoelLewis/finance_skills
**引入日期：** 2026-04-23
**审计：** 通过（全部为方法论文档，无危险指令）

## 为什么选这 5 个

| Skill | 大小 | 覆盖 methodology.md 缺口 |
|---|---|---|
| **performance-attribution** | 10 KB | 🔴#2 Brinson 归因（修 performance.md 简化版升级） |
| **asset-allocation** | 10 KB | SAA 升级：Black-Litterman / Risk Parity / Glide Path |
| **bet-sizing** | 10 KB | 🟡#4 数学化组合：Kelly / 分数 Kelly / 风险预算 |
| **historical-risk** | 8 KB | 🟢#7 压力测试：Volatility / 最大回撤 / VaR / Parkinson |
| **rebalancing** | 16 KB | 再平衡升级：Threshold bands / Tax-efficient / Volatility harvesting |

## 未选的（暂不需要）

wealth-management plugin 还有 25 个 skill，覆盖保险、海外税、数字资产等，目前和我们场景不匹配。

core plugin（return-calculations / statistics-fundamentals / time-value-of-money）基础，Claude 原本就会，不装。

trading-operations（counterparty-risk / margin-operations 等）机构级，不适合个人 DCA。

**未来需要时再按同样方式按需拉。**

## 触发关键字

| 你说的话 | 激活 |
|---|---|
| "归因分析" / "α 怎么来的" / "Brinson" | performance-attribution |
| "怎么配股债比例" / "60/40" / "Risk Parity" / "Black-Litterman" | asset-allocation |
| "NVDA 该放多少仓位" / "Kelly" / "单股上限多少合理" | bet-sizing |
| "最大回撤" / "历史波动率" / "VaR" / "Parkinson" | historical-risk |
| "什么时候再平衡" / "偏离多少该动" / "tax-efficient 再平衡" | rebalancing |

## 具体用法示例

### 场景 1：升级 performance.md 的 Brinson 归因

现在 performance.md 第 2b 节只有手算的简单 Brinson。季度扫描时用 performance-attribution skill 做完整版：
- Multi-period linking
- Interaction effect 单独拆出
- Factor-based attribution（Fama-French 三因子）

### 场景 2：验证 v3 是否"数学最优"

季度/年度 review 时用 asset-allocation + bet-sizing：
- MVO 给定历史 8 年数据算最优权重，对比当前 v3 偏差
- Kelly 公式验证 NVDA 15% 是不是合理上限（Kelly 过激，分数 Kelly 1/4 更稳）
- Risk Parity 看若每只等风险贡献，该如何重配

**若结果显示 v3 远非最优** → 写 `reweight-*.md` 提案

### 场景 3：压力测试

规模 > 50 万时必做。historical-risk：
- 2008（-50%）、2020（-34%）、2022（-25%）情景下模拟当前组合
- 算 95% VaR（月度）+ 最大回撤预期
- Parkinson 估计当前隐含波动

### 场景 4：升级再平衡规则

现在 portfolio-config.txt 的"±5% 偏离"是启发式。rebalancing skill 讨论：
- Threshold vs Calendar 何时用哪个
- Volatility harvesting（波动套利）
- Tax-efficient rebalancing（美股对我们非美居民资本利得免税，次要；但 wash sale 要避）

## 关键改造（与原版差异）

**原版可能依赖：**
- 各自 scripts/ 下的 Python 实现
- 某些特定数据源

**我们的用法：**
- **不用 scripts**（只保留 SKILL.md 方法论）
- Claude 按 SKILL.md 的公式直接算
- 数据源复用项目已有的 FMP + WebSearch

## 维护

- 半年一次检查是否有新版本
- 如果项目 fork（改阈值适配 v3），归档到 `research/proposals/rule-*.md`
- 这些是稳定的数学方法论，改动会比 ancs21 少

## 许可证

原项目见 https://github.com/JoelLewis/finance_skills 说明。

## 版本

- 版本：1.0（2026-04-23）
- 下次同步：2026-10-23 或需要新 skill 时
