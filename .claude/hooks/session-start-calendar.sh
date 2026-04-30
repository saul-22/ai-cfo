#!/bin/bash
# SessionStart hook: 自动检查今天 vs 关键投资日期，输出到 stdout 注入 Claude context
#
# 触发：每次新会话开始
# 输出：日历提醒 + SOP 触发建议（让 Claude 一进来就知道今天有什么任务）

set -e

TODAY=$(date +%Y-%m-%d)
TODAY_MONTH=$(date +%m)
TODAY_DAY=$(date +%d)
TODAY_YEAR=$(date +%Y)

# 计算到下次定投（每月 25 日）的天数
if [[ $TODAY_DAY -le 25 ]]; then
    NEXT_DCA_DAYS=$((25 - TODAY_DAY))
    NEXT_DCA="本月 25 日 ($NEXT_DCA_DAYS 天后)"
else
    NEXT_MONTH_DCA_TS=$(date -j -v+1m -v25d -v0H -v0M -v0S +%s 2>/dev/null || echo 0)
    TODAY_TS_NOW=$(date +%s)
    NEXT_DCA_DAYS=$(( (NEXT_MONTH_DCA_TS - TODAY_TS_NOW) / 86400 ))
    NEXT_DCA="下月 25 日 ($NEXT_DCA_DAYS 天后)"
fi

# 季度扫描日：8/1, 11/1, 2/1
SCAN_DATES=("$TODAY_YEAR-08-01" "$TODAY_YEAR-11-01" "$((TODAY_YEAR + 1))-02-01")
NEXT_SCAN=""
for d in "${SCAN_DATES[@]}"; do
    SCAN_TS=$(date -j -f "%Y-%m-%d" "$d" +%s 2>/dev/null || echo 0)
    TODAY_TS_NOW=$(date +%s)
    if [[ $SCAN_TS -gt $TODAY_TS_NOW ]]; then
        DAYS=$(( (SCAN_TS - TODAY_TS_NOW) / 86400 ))
        NEXT_SCAN="$d ($DAYS 天后)"
        break
    fi
done

# 年度 review：每年 1/1-1/15
IN_ANNUAL_REVIEW="否"
if [[ "$TODAY_MONTH" == "01" && $TODAY_DAY -le 15 ]]; then
    IN_ANNUAL_REVIEW="✅ 是（必须跑 investment/runbooks/annual-review.md 8 项）"
fi

# W-8BEN：2029-03 到期，每年 3 月提醒
W8BEN_REMINDER=""
if [[ "$TODAY_MONTH" == "03" ]]; then
    YEARS_TO_EXPIRY=$((2029 - TODAY_YEAR))
    W8BEN_REMINDER="3 月 = W-8BEN 检查月 (剩余 $YEARS_TO_EXPIRY 年到期，必须跑 tax-compliance skill)"
fi

# 跨年归档：12/15-12/31
YEAR_END_REMINDER=""
if [[ "$TODAY_MONTH" == "12" && $TODAY_DAY -ge 15 ]]; then
    YEAR_END_REMINDER="跨年归档窗口：ledger 和 scan-history 当前文件即将归档到 archive/$TODAY_YEAR/"
fi

DCA_PREP=""
if [[ $TODAY_DAY -ge 22 && $TODAY_DAY -le 25 ]]; then
    DCA_PREP="临近定投日 (距 25 日 $NEXT_DCA_DAYS 天) — 应主动建议跑 monthly-portfolio-plan + 生成 buy-order"
fi

POST_DCA=""
if [[ $TODAY_DAY -ge 26 && $TODAY_DAY -le 31 ]]; then
    POST_DCA="月中 ($TODAY_DAY 日) — 检查用户是否已反馈成交，未反馈则主动追问 + 提醒查分红"
fi

WEEKDAY=$(date +%u)
WEEKLY_RISK=""
if [[ "$WEEKDAY" == "7" ]]; then
    WEEKLY_RISK="今日周日 — 应主动建议跑 weekly-risk-scan runbook"
fi

# 输出（会被注入 Claude context）
cat << EOF
[日历检查 — $TODAY]

📅 关键日期：
- 下次定投：$NEXT_DCA
- 下次季度扫描：$NEXT_SCAN
- 年度 Review 窗口：$IN_ANNUAL_REVIEW
$([ -n "$W8BEN_REMINDER" ] && echo "- $W8BEN_REMINDER")
$([ -n "$YEAR_END_REMINDER" ] && echo "- $YEAR_END_REMINDER")

🎯 今日触发的 SOP：
$([ -n "$DCA_PREP" ] && echo "- $DCA_PREP")
$([ -n "$POST_DCA" ] && echo "- $POST_DCA")
$([ -n "$WEEKLY_RISK" ] && echo "- $WEEKLY_RISK")

⚙️ 行为指引：
- 用户问投资类问题 → 跑 /sop（SOP 完整流程）
- 用户问个股/白纸/独立分析 → 跑 /research、/audit、/greenfield（subagent 隔离，禁读 v3）
- 用户问非投资事 → 正常答，不必跑 SOP
EOF

exit 0
