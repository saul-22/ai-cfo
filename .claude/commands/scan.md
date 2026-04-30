---
description: 季度扫描（每年 8/1、11/1、2/1，跑全套 skill 评估持仓 + 候选池）
---

进入**季度扫描模式**。流程长（30-60 分钟），多套 skill 全跑，**强制 spawn subagent 执行**避免污染主上下文。

**Step 0：主 Claude 准备**
1. 读 **`investment/EXECUTION-CONTEXT.md`**（当前组合 + 信念 + 历史决策，执行模式必读）
2. 读 `investment/portfolio-config.txt` + `investment/holding-summary.md`（执行类，注入持仓正常）
3. 确认今天是季度首日，或用户明确说"季度扫描"

**Step 1：spawn 1 个 subagent 跑全套评估**

subagent_type: "general-purpose"

prompt：

```
你是季度扫描 Agent。任务是完整评估当前持仓 + 扫描候选池。

可读：
- investment/portfolio-config.txt（当前组合）
- investment/holding-summary.md（最新数据）
- investment/records/scan-history.md（历史扫描）
- investment/records/decision-journal.md（thesis）
- ips.md（约束）
- skills/ 全部
- .env.local（FMP key）

任务清单（严格按顺序，缺一作废）：

A. 当前持仓深度审核
1. 对每只跑 stock-audit（CANSLIM + F-Score）
2. 对每只跑 ancs21 至少 4 个 persona（Buffett / Graham / Lynch / Munger）
3. 对每只跑 institutional-flow-tracker（13F 机构持仓）
4. 标注：PASS / CONDITIONAL / FAIL + 红灯项

B. 大盘环境
1. tradermonty/macro-regime-detector：当前 regime
2. tradermonty/market-top-detector：顶部概率 0-100
3. tradermonty/us-market-bubble-detector：泡沫风险
4. joellewis/historical-risk：组合 VaR + 最大回撤

C. 候选池扫描
1. us-stock-scanner：从市场扫候选股
2. canslim-screener：批量打分
3. fscore-screener：批量打分
4. 对前 5 名跑 stock-audit + ancs21
5. 列入或更新 research/stock-dossiers/ 候选池

D. 组合数学
1. joellewis/asset-allocation：MVO 算理论权重 vs 当前权重
2. joellewis/bet-sizing：Kelly 算每只理想仓位
3. joellewis/rebalancing：偏离阈值检查
4. joellewis/performance-attribution：上季度归因

E. 综合判定
- 是否触发换股 / 调比例（任一持仓 FAIL 或个股特别条款触发）
- 是否进入 bear-market-playbook（按 portfolio-config.txt 大盘回撤档位）
- 候选池是否有 PASS 标的可纳入 watchlist

输出：完整季度扫描报告。落到 investment/records/scan-history.md "季度扫描"段，含元数据。

如发现需要换股/调比例 → 不要直接改 portfolio-config，而是在 research/proposals/ 生成提案文件等用户审批。
```

**Step 2：主 Claude 收 subagent 报告**
- 转述给用户（包含核心判定 + 红灯项）
- 如 subagent 生成了提案（research/proposals/），**主动提醒用户**走提案审批流程（独立 Agent 复审）
- **禁止**主 Claude 自己改 portfolio-config（受 hook 保护）

**Step 3：归档**
- subagent 已写入 scan-history.md 季度段
- 主 Claude 检查 git status，如未自动 commit 则手动 commit
