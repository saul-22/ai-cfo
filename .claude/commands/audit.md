---
description: 单股独立 stock-audit 评分（纯净模式）。调用 audit-isolated agent，物理隔离当前持仓。
argument-hint: <TICKER>
---

待审股票：**$ARGUMENTS**

**强制调用 Agent 工具，`subagent_type: "audit-isolated"`。** 不让主 Claude 参与评分推导。

prompt 给 agent：`对 $ARGUMENTS 跑完整 stock-audit 流程（CANSLIM + F-Score + ancs21 4 persona + 综合判定）`。

主 Claude 收到报告后：原样转述 + 标注 `[独立审核 $ARGUMENTS]`。禁止主动追加"用户现在持仓里 <某股> X%，所以 $ARGUMENTS 会冲突..."类对比。
