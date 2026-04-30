---
name: 投资项目刚性 SOP
description: ai-cfo 项目每次会话进来必须先跑会话启动 SOP，不可跳步直接回答用户问题
type: feedback
---
每次进入 ai-cfo 项目（即任何已 fork 出来的、根目录有 CLAUDE.md + ips.md 的工作目录），必须先依次完成：

1. 读 `investment/holding-summary.md`（持仓 + 偏离 + 本月状态）
2. 读 `investment/performance.md`（累计业绩 + 月度明细）
3. 读 `investment/buy-order.txt`（本月待执行）
4. 读 `investment/records/scan-history.md`（监控级标的）
5. 读 `investment/records/decision-journal.md`（上次决策 thesis）
6. 检查今天 vs 关键日期（定投日、季度扫描日、紧急触发日）
7. 主动汇报 5 段式开场白：进度 / 持仓 / 待办 / 风险 / 建议
8. 才回答用户问题

**Why:** 投资链路一旦断裂会丢失风控信号（错过紧急触发、漏掉监控级标的、跳过偏离校正），损失不可逆。用户不会记得上次会话链路到哪一步——必须由 Claude 主动汇报。

**How to apply:**
- 不论用户问什么（包括"今天天气怎样""帮我看下文件夹"），如果命中 SOP 触发条件（见 CLAUDE.md），都必须先跑 SOP
- 唯一例外：用户明确说"不用跑 SOP"或"只回答问题别更新"
- SOP 内容固化在项目 CLAUDE.md 顶部，每次自动加载
- 永远先读文件再发言，禁止凭印象回答持仓数据

**SOP 不触发的情况：** 用户问与投资完全无关的事（"改一下 docs 目录的文件"），正常回答即可，不必硬跑 SOP。
