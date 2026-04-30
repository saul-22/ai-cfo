# 快速参考（1 页纸）[TEMPLATE]

> 平时只看这个。详细规则在 CLAUDE.md 和 investment/runbooks/。

---

## 每月固定动作

| 日期 | 动作 | 文件 |
|---|---|---|
| 每周日 | 说"周风控" | `investment/runbooks/weekly-risk-scan.md` |
| 每月 25 日（或固定定投日） | 说"开始本月定投" | `investment/buy-order.txt` |
| 下单后 | 反馈成交 + 汇率 + 分红 | Claude 自动跑月度闭环 |
| 每季末 | 说"季度自审" | `investment/runbooks/quarterly-self-audit.md` |
| **每年 1 月** | **说"年度 review"** | `investment/runbooks/annual-review.md`（8 项） |

---

## 查什么看哪个

| 想看 | 文件 |
|---|---|
| 本月要买什么 | `investment/buy-order.txt` |
| 当前市值收益 | `investment/holding-summary.md` |
| 历史收益表 | `investment/performance.md` |
| 当前配置 | `investment/portfolio-config.txt` |
| 组合版本演进 | `investment/portfolio-versions.md` |
| 投资宪法 | `ips.md` |
| 历史买入流水 | `investment/records/investment-ledger.md` |
| 决策日记 | `investment/records/decision-journal.md` |
| 翻历史 | `investment/archive/YYYY/INDEX.md` |

---

## 关键数字（按你的配置填）

| 项 | 当前 |
|---|---|
| 月投入 | <X,XXX> <currency> |
| 组合版本 | v<N> |
| 持仓 | <按 portfolio-config.txt 填> |
| 目标 | 见 `ips.md` 第 2 节 |
| Benchmark | <主：SPY 或本地大盘> + <次：Policy Portfolio> |

---

## 下次重要日期

> 项目运行后填入实际日期。

| 日期 | 事件 |
|---|---|
| YYYY-MM-DD | 本月定投 |
| YYYY-MM-DD | 季度扫描 |
| YYYY-MM-DD | 年度再平衡（建仓周年）|
| YYYY-MM | W-8BEN 续签（如适用）|
| YYYY-MM | 月投入递增 |

---

## 紧急时做什么

**大盘回撤时：** `investment/playbooks/bear-market-playbook.md`（熊市心理预案）
- -10% 到 -15%：小回调，继续 DCA
- -15% 到 -20%：现金仓档位 2 触发
- -20% 到 -30%：档位 3 触发，拒绝清仓
- -30% 到 -35%：档位 4，全部现金投入
- > -35%：策略复盘（不是清仓）

**单股事件：** 跌 >40% / CEO 离职 / SEC / 财务造假
- 立刻告诉 Claude 事件
- Claude 24 小时内跑 `emergency-audit.md` 7 步
- 决策 HOLD / REDUCE / EXIT

---

## 备份 + 恢复

- **本地 Git：** 所有历史自动保留
- **远程：** <按你自己的 Git 远程地址填>
- **误删恢复：** `git checkout HEAD -- <文件>`
- **整个项目丢失：** `git clone <你的远程>`

---

## 如何验证 Claude 跑方案没偷懒

当 Claude 给你一份"组合方案报告"时，逐项对照 `investment/runbooks/methodology-output-template.md` 的自检清单。

**快速验证 10 秒法（字段层）：**
- 报告顶部有没有 `steps-completed: N/N` 字样？没有 → Claude 跳步
- 评分矩阵是否每列全满？有空 → 没真跑该 filter
- 数学结论是否具体（不是"约""大概"）？没数字 → 没真算
- 历史压力测试数字都在？缺 → 没做
- failure mode 都有概率估？少或没估 → Munger 反向跳了
- 决策结论明确勾选？模糊 → 没决策

**深度验证（质量层，5 个 why）：**
- 报告底部"自审核 5 题"有没有回答？没有 → 报告不合格
- 问 why 1：为什么这几个行业（不是别的）？
- 问 why 2：为什么这几只股（不是同赛道其他）？
- 问 why 3：为什么这个比例（不是别的数字）？
- 问 why 4：和当前版本差在哪（具体 trigger 是什么）？
- 问 why 5：3 个最可能失败的原因？

**发现偷懒：** 让 Claude "重跑 Step X"，不接受任何借口。

---

## 给未来自己 / 家人的话

- 这个系统设计让你长期不用操心
- Claude 负责决策，你只负责下单 + 反馈
- 遇到任何"感觉要改方案"的冲动 → 跑触发检查（IPS 6 项均未满足就不动）
- 相信时间 + 复利，不相信直觉 + 择时
- 文档在 Git，硬盘坏了也不会丢
