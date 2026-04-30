---
name: us-stock-scanner
description: Use when running a quarterly portfolio review, scanning US stocks for possible replacements, checking holding health, or testing whether the live portfolio still fits its current rules and diversification targets.
---

# US Stock Scanner

## Overview

This skill runs the quarterly review layer for the live US stock portfolio. It checks current holdings, scans for replacement candidates, and proposes changes when the evidence is strong enough.

It is an analysis and recommendation skill, not the monthly execution skill.

**Non-negotiable boundaries:**
- Read the live portfolio files first.
- Keep recommendations aligned with the current portfolio rules.
- Do not redesign the framework during a routine scan.
- Any proposed holding change should pass `stock-audit` before execution.

## Integrated Skills

Use the project-local copies so the workflow stays self-contained.

### 1. canslim-screener
- **Location:** `./skills/canslim-screener/`
- **Use for:** finding ranked growth candidates during opportunity scans

### 2. institutional-flow-tracker
- **Location:** `./skills/institutional-flow-tracker/`
- **Use for:** checking institutional accumulation or distribution in current and candidate holdings

### 3. quantitative-research
- **Location:** `./skills/quantitative-research/`
- **Use for:** evaluating quantitative claims with bias awareness and simple-method discipline

If FMP data is unavailable, fall back to web-search-only mode and say so clearly.

## Persistent Files

**All files are in:** `./investment/`

| File | Purpose | Access |
|------|---------|--------|
| `portfolio-config.txt` | Canonical holdings, ratios, risk rules | **READ + WRITE** with user approval for holding changes |
| `records/investment-ledger.md` | Actual executed buys | **READ only** |
| `records/scan-history.md` | Quarterly review archive | **WRITE** |

## When to Use

**Use for:**
- "Run the quarterly review"
- "Check whether my holdings are still healthy"
- "Find replacement candidates"
- "Scan the market for possible swaps"
- "Do I need to change anything this quarter?"

**Do not use for:**
- monthly buy-list generation,
- ad hoc timing calls,
- changing the investing philosophy,
- non-US stock scans.

## Canonical Portfolio Source

Always read:

```text
./investment/portfolio-config.txt
./investment/records/investment-ledger.md
```

Use `portfolio-config.txt` as the live authority for:
- holdings: 从 `portfolio-config.txt` 读取,
- 分层结构（T1/T2/T3/T4 占比从 config 读取）,
- 单股穿透上限（从 config 读取）,
- 板块集中上限（从 config 读取）,
- drawdown handling language.

### Current portfolio context

| Tier | Role | Current live structure |
|------|------|------------------------|
| T1 | Core | 见 `portfolio-config.txt` |
| T2 | Growth | 见 `portfolio-config.txt` |
| T3 | Hedge | 见 `portfolio-config.txt` |
| T4 | Cash | 现金储备 |

## Workflow

### 1. Market environment check

Assess the broad backdrop:
- market trend,
- volatility,
- rates backdrop,
- major macro risks.

Use this to frame caution, not to force portfolio redesign.

### 2. Current holdings health check

Review each live holding.

For stocks, assess:
- revenue trend,
- earnings trend,
- competitive position,
- institutional flow,
- major news or thesis breaks.

For ETFs, assess:
- role fit,
- overlap,
- fee and liquidity quality,
- whether they still match the portfolio's purpose.

Use simple statuses:
- **HOLD**
- **WATCH**
- **REPLACE CANDIDATE**

### 3. Portfolio rule check

Check whether the current portfolio still fits the live rules:
- 40/30/20/10 allocation structure,
- single-stock exposure remains below 20% after ETF look-through,
- tech exposure remains below 70%,
- T3 remains a real hedge rather than extra tech.

### 4. Opportunity scan

Only look for candidates that could realistically improve the existing portfolio.

Preferred inputs:
- CANSLIM screens,
- institutional-flow screens,
- targeted web research.

Candidate standards should reflect role:
- **T2 candidates:** proven, scalable, large enough to be durable
- **T3 candidates:** only if the hedge role is explicitly under review; default assumption is that the live hedge remains unless a strong case emerges

Do not bias scans with stale assumptions such as XLV, VOO, AMD, SMCI, or IONQ being current holdings.

### 5. Validate candidate fit

Before recommending a swap, check:
- overlap with broad-market ETFs and existing direct holdings,
- effect on tech concentration,
- effect on the 20% single-stock cap,
- whether the change improves diversification or only adds excitement.

Any serious proposal should be routed through `stock-audit`.

### 6. Write the quarterly report

Update `records/scan-history.md` with:
- date,
- market context,
- data sources used,
- holdings health table,
- candidate list,
- recommended actions,
- whether any audit is required next.

If the user approves a holding change, then update `portfolio-config.txt` and record the reason in the change log.

## Output Structure

```markdown
# Quarterly Portfolio Scan Report

**Date:** [YYYY-MM-DD]
**Quarter:** [QX YYYY]

## 1. Market Environment
[short summary]

## 2. Holdings Health Check
| Ticker | Tier | Status | Key reason |
|--------|------|--------|------------|
| <TICKER> | T1 | HOLD | ... |
| <TICKER> | T1 | HOLD/WATCH/REPLACE CANDIDATE | ... |
| <TICKER> | T2 | ... | ... |
| <TICKER> | T3 | ... | ... |

## 3. Portfolio Rule Check
- Single-stock cap: [pass / issue]
- Tech concentration cap: [pass / issue]
- Hedge role integrity: [pass / issue]

## 4. Candidate Watchlist
| Ticker | Intended role | Why it qualifies | Main risk |
|--------|----------------|------------------|-----------|

## 5. Recommended Actions
- [Hold / Audit / Review next semi-annual window]
```

## Scan Modes

### Quick scan
Use for a lighter quarterly check:
- market environment,
- holdings health,
- portfolio rule check,
- no deep candidate list unless a current holding is weakening.

### Full scan
Use when:
- a holding is weakening,
- the user asks for replacements,
- the semi-annual review window is open,
- there is a major market or thesis change.

## Important Rules

1. **Quarterly role only** — do not turn this into a monthly tool.
2. **Bias toward inaction** — HOLD is the default unless evidence says otherwise.
3. **Use live rules** — Tier 比例、单股上限、板块上限均以 `portfolio-config.txt` 为准。
4. **Keep T3 honest** — it should remain a real diversifier unless the framework is deliberately changed.
5. **Use project-local skill paths** for supporting analysis.
6. **Avoid stale portfolio commentary** that assumes old holdings are current.
7. **Escalate real changes to `stock-audit`** before they become execution decisions.

**Version:** 1.2
**Updated:** YYYY-MM-DD
**Frequency:** Quarterly
**Companion skills:** `stock-audit`, `monthly-portfolio-plan`
