# ai-cfo — 让 AI 像 CFO 一样管理你的投资组合

![License](https://img.shields.io/badge/license-MIT-blue)
![Status](https://img.shields.io/badge/status-v1.0-green)
![Claude Code](https://img.shields.io/badge/Claude_Code-required-purple)
![Strategy](https://img.shields.io/badge/Strategy-Long_Term_DCA-blue)
![Skills](https://img.shields.io/badge/Skills-27_Integrated-orange)
![Automation](https://img.shields.io/badge/Automation-Git_Hooks-red)

<p align="center">
  <strong>专业投资管理流程 × Claude Code = 零情绪决策的长期投资系统</strong>
</p>

---

## 核心价值

你是否遇到过这些问题？

- **凭感觉投资**：没有系统，每次都在"这次不一样"中追涨杀跌
- **记不住规则**：定好的策略执行到一半就忘了，或者情绪一来就破戒
- **恐慌性操作**：大跌时不知道该加仓还是止损，全凭当时心情
- **没有复盘**：赚了亏了都不知道为什么，下次还是重复同样的错误
- **耗时费力**：每月定投要花半天研究，季度调仓更是拖延症发作

**ai-cfo 解决的就是这些问题。**

它把机构投资者的专业流程（IPS、风控、归因、提案审批）编码成 Claude Code 能执行的自动化工作流，让你：

- **每月 5 分钟完成定投** — 说一句"开始本月定投"，Claude 自动生成买入清单  
- **零情绪决策** — 所有决策基于预设规则，不受市场恐慌/贪婪影响  
- **完整记录可追溯** — 每笔交易、每次决策都有 Git 记录，随时复盘  
- **分级风控响应** — 周扫描、季度审核、紧急触发，该动时动、该守时守  
- **独立研究不污染** — 想研究新股票？隔离模式确保不被现有持仓影响判断

## 这是什么

**ai-cfo 是一套投资工作流框架，不是投资建议、不是产品、不是托管系统。**

它是一套"投资操作系统"：

- **IPS（投资政策声明）** — 你的投资宪法，定义目标、风险、规则
- **27 个 Skills** — 月度定投、风控扫描、选股审核、归因分析...
- **7 个 Runbooks** — 月度/周度/季度/年度/紧急流程手册
- **3 个隔离 Agents** — 独立研究、白纸构建、单股审核（物理隔离持仓）
- **自动化 Hooks** — 自动 commit、自动日历提醒、自动提案复审

**适合 5-20 年长期 DCA 策略，不适合日内交易、择时、量化。**

## 快速演示

**场景 1：月度定投（每月 5 分钟）**

```
你：开始本月定投

Claude：
📍 当前进度：本月第 4 个月
💼 最新持仓：$12,500，+8.3%，无偏离告警
📋 待办事项：生成 2026-05 买入清单
⚠️ 风险监控：全部持仓通过周风控
👉 建议下一步：生成本月 buy-order

[5 秒后]

✅ 已生成 buy-order.txt：
   SPY   $175  →  0.325 股
   QQQ   $105  →  0.217 股
   ...
   
请在券商下单，完成后反馈成交价。
```

**场景 2：紧急事件（单股暴跌）**

```
你：EXMP 跌了 35%，看下要不要动

Claude：
🚨 触发紧急审核流程
📊 正在跑 stock-audit...
   - 基本面：营收增长放缓但仍 +25%
   - 估值：PE 从 45 降到 29，接近历史低位
   - 机构动向：13F 显示 3 家增持
   - 技术面：RSI 超卖
   
✅ 结论：HOLD
理由：短期情绪过度反应，基本面未恶化，建议继续定投。

已记录到 decision-journal.md
```

**场景 3：独立研究（不被现有持仓影响）**

```
你：独立看一下 DEMO 这只股票

Claude：
[启动隔离 subagent，禁读当前持仓]

📊 DEMO Inc 独立分析：
   - 行业：AI 芯片
   - 护城河：GPU 垄断 85% 市场份额
   - 增长：数据中心营收 YoY +217%
   - 估值：Forward PE 35（行业中位 28）
   - 风险：客户集中度高、地缘政治
   
评分：78/100（PASS）

[独立分析，未对照当前组合]
```

## 核心特性

### 策略-执行隔离

**问题**：研究新股票时，很容易被"我已经持有 X"影响判断。

**解决**：物理隔离的 subagent，研究时完全不知道你当前持仓什么。

```
默认模式 = 知道持仓（月度定投、风控、记录）
隔离模式 = 物理切断（独立研究、白纸构建、单股审核）
```

### 提案审批流程

**问题**：情绪化换股，事后后悔。

**解决**：任何组合变更必须先写提案 → 独立 Agent 复审 → 你审批 → 才能执行。

6 项触发条件（紧急、季度、违规、里程碑...），不满足就不让改。

### Git 全程记录

**问题**：记不住上次为什么买/卖，无法复盘。

**解决**：每次交易、每次决策自动 `git commit`，随时回溯。

```bash
git log investment/  # 看所有投资决策历史
git show <commit>    # 看某次决策的完整上下文
```

### 专业级工具链

集成 3 位作者的 20 个投资 skill：

- **ancs21** — 10 个大师 persona（Buffett/Graham/Lynch/Munger...）
- **tradermonty** — 5 个市场分析（regime/top/bubble/scenario/sizer）
- **joellewis** — 5 个组合数学（attribution/allocation/sizing/risk/rebalancing）

### 自动化 Hooks

- **session-start** — 自动检查日历，提醒定投日/扫描日/到期事项
- **auto-commit** — 修改 `investment/` 文件自动 commit
- **proposal-trigger** — 生成提案后自动启动独立复审

## 快速开始

### 1. Fork 并 Clone

```bash
git clone https://github.com/你的用户名/ai-cfo.git
cd ai-cfo
```

### 2. 配置 API Key（可选）

```bash
cp .env.example .env.local
# 编辑 .env.local，填入 FMP_API_KEY
# 免费注册：https://site.financialmodelingprep.com/developer/docs
```

### 3. 在 Claude Code 中打开

```bash
claude
```

### 4. 填写你的投资政策

按顺序填写这 4 个模板（参考 `investment/EXAMPLE-filled.md`）：

1. **`ips.md`** — 投资宪法（目标、风险、规则）
2. **`investment/portfolio-config.txt`** — 目标组合（持仓、比例、风控）
3. **`investment/holding-summary.md`** — 当前驾驶舱
4. **`investment/performance.md`** — 业绩跟踪

### 5. 开始第一次会话

```
你：开始本月定投
```

Claude 会自动跑完整 SOP，生成买入清单。

## 架构一览

```
ai-cfo/
├── CLAUDE.md                ← Claude 的系统 prompt（SOP + 隔离规则）
├── ips.md                   ← 投资宪法模板
│
├── investment/              ← 执行线（DCA、记录、风控）
│   ├── portfolio-config.txt ⭐ 主计划
│   ├── buy-order.txt        ⭐ 本月执行单
│   ├── holding-summary.md   ⭐ 当前驾驶舱
│   ├── performance.md       ⭐ 业绩跟踪
│   ├── runbooks/            ← 月/周/季/年/紧急流程手册
│   └── playbooks/           ← 熊市/边界场景应急手册
│
├── research/                ← 策略线（探索、提案、宏观观察）
│   ├── methodology.md       ← 10 步专业方法论
│   ├── runbook-A-greenfield.md
│   ├── runbook-B-current-review.md
│   └── proposals/           ← 唯一桥梁：策略 → 执行
│
├── skills/                  ← 27 个 skill
│   ├── monthly-portfolio-plan/
│   ├── stock-audit/
│   ├── us-stock-scanner/
│   ├── _external/
│   │   ├── ancs21/         (10 persona)
│   │   ├── tradermonty/    (5 skill)
│   │   └── joellewis/      (5 skill)
│
└── .claude/
    ├── agents/              ← 3 个隔离 subagent
    ├── commands/            ← 7 个 slash commands
    └── hooks/               ← 自动化 hooks
```

## 适合谁

### 适合

- **长期投资者**：5-20 年周期，每月固定金额 DCA
- **系统化思维**：愿意先定规则、再执行，不凭感觉
- **会用 Claude Code**：能在终端/IDE 里和 AI 对话
- **想要可追溯**：重视记录、复盘、归因

### 不适合

- **短线交易者**：日内/波段/量化（框架是为 DCA 设计的）
- **想要 GUI**：这是 CLI 工作流，不是 SaaS 产品
- **期待"跟单"**：框架不推荐具体股票，你要自己填 IPS
- **不想学习**：需要理解 IPS、runbook、提案流程

## 文档

- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** — 1 页纸快速参考
- **[CLAUDE.md](CLAUDE.md)** — 完整的系统 prompt 和设计哲学
- **[ips.md](ips.md)** — 投资政策声明模板
- **[investment/EXAMPLE-filled.md](investment/EXAMPLE-filled.md)** — 填好后的样子（虚构数据）

## 致谢

本框架引用并集成了三位作者的优秀投资 skill：

- **[ancs21/ai-sub-invest](https://github.com/ancs21/ai-sub-invest)** — 10 个投资大师 persona
- **[tradermonty/claude-trading-skills](https://github.com/tradermonty/claude-trading-skills)** — 5 个市场分析 skill
- **[JoelLewis/finance_skills](https://github.com/JoelLewis/finance_skills)** — 5 个组合数学 skill

## 免责声明

**ai-cfo 不是投资建议，不是合规咨询，不是托管系统。**

- 框架本身不持有资金、不下单、不建议具体股票
- 模板里的占位符（`<TICKER>`、`<X>%`）由你自己填
- Claude 在你会话中给出的建议是基于你提供的 IPS 和数据，**最终决策和执行由你承担**
- 投资有风险，本框架对任何使用本框架做出的投资决策造成的损失不承担任何责任

详见 [LICENSE](LICENSE) 中的免责声明。

## License

MIT License - 详见 [LICENSE](LICENSE)

---

<p align="center">
  <strong>⭐ 如果这个项目对你有帮助，欢迎 Star！</strong>
</p>
