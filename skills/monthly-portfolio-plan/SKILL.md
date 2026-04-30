---
name: monthly-portfolio-plan
description: Use when the user wants this month's buy list, DCA allocation, or exact buy amounts for the current portfolio, including monthly execution, share-count calculation, and ledger updates.
---

# Monthly Portfolio Plan

## Overview

This skill generates the monthly execution list for the live portfolio. It is an execution skill, not a decision skill.

**Non-negotiable boundaries:**
- Read `portfolio-config.txt` before calculating anything.
- Use <currency> as the planning currency because the live portfolio is <currency>-based.
- Do not change holdings, tier targets, or portfolio rules here.
- Do not modify `portfolio-config.txt` from this skill.

## Persistent Files

**All files are in:** `./investment/`

| File | Purpose | Access |
|------|---------|--------|
| `portfolio-config.txt` | Canonical holdings, ratios, limits, risk rules | **READ only** |
| `records/investment-ledger.md` | Monthly execution record | **READ + WRITE** |
| `records/scan-history.md` | Recent scan and audit context | **READ only** |

## When to Use

**Use for:**
- "What should I buy this month?"
- "Run the monthly plan"
- "Generate this month's buy list"
- "How do I split this month's <月预算> <currency>?"
- "Calculate shares for the current portfolio"

**Do not use for:**
- Deciding whether holdings should change
- Quarterly portfolio review
- Stock replacement decisions
- Portfolio redesign

Use `us-stock-scanner` for quarterly review and `stock-audit` before any holding change.

## Canonical Portfolio Source

Always read:

```text
./investment/portfolio-config.txt
```

Use it as the only truth source for:
- holdings,
- tier allocation,
- monthly <currency> amounts,
- single-stock cap,
- tech concentration cap,
- drawdown response rules.

### Current fallback defaults

Use these **only if the config file is unavailable**. They must match the live portfolio (see `investment/portfolio-versions.md` for current version):

| Tier | Ratio | <currency>/month |
|------|-------|-----------|
| T1 Core | 40% | <月预算>×0.40 |
| T2 Growth | 30% | <月预算>×0.30 |
| T3 Hedge | 20% | <月预算>×0.20 |
| T4 Cash | 10% | <月预算>×0.10 |

> Specific tickers and amounts: always read from `portfolio-config.txt`. Do not hardcode here.

## Workflow

### 1. Read the live files

In order:
1. Read `portfolio-config.txt`
2. Read the latest relevant entries in `records/scan-history.md`
3. Read the latest relevant entries in `records/investment-ledger.md`

### 2. Confirm execution inputs only if needed

Ask only if missing:
- this month's budget in <currency>,
- whether the user wants the default portfolio amounts,
- whether the broker supports fractional shares,
- whether the user already completed any buys that must be recorded.

If the user says to use defaults, use the live config values.

### 3. Fetch market prices

Get current prices for the live holdings (read tickers from `portfolio-config.txt`).

If the market is closed, use the latest close.

### 4. Convert <currency> budget into executable buy amounts

Use the <currency> allocation from `portfolio-config.txt`.

For each holding:
1. Start from <currency> budgeted amount.
2. Convert to USD only if needed for share math.
3. Calculate shares from current USD price.
4. If fractional shares are supported, use precise shares.
5. If not, round down and report leftover <currency>.

For formula style and wording, reuse:

```text
./skills/monthly-portfolio-plan/references/allocation-math.md
```

### 5. Apply drawdown handling from the live rules

Use the drawdown logic from `portfolio-config.txt`.

Practical summary:
- Normal market conditions: follow the standard plan.
- Broad market drawdown >20%: evaluate deploying T4 cash into T1.
- Broad market drawdown >30%: pause new T3 buying and redirect that month's T3 funds into T1.

Do not invent alternative thresholds here.

### 6. Output the buy list

Keep the output short and executable.

```markdown
# Monthly Buy List - [Month Year]

**Budget:** [X] <currency>
**Execution date:** 每月固定日（按 ips.md 第 9 节）
**FX used:** [USD/<currency> if needed]
**Market condition:** [Normal / Drawdown]

## Buy Orders

| # | Ticker | Price (USD) | Budget (<currency>) | Shares | Notes |
|---|--------|-------------|--------------|--------|-------|
| 1 | <TICKER> | ... | <X> | ... | ... |
| 2 | <TICKER> | ... | <X> | ... | ... |
| ... | ... | ... | ... | ... | ... |

## Cash Reserve

| Destination | Amount (<currency>) | Notes |
|-------------|--------------|-------|
| Money market / high-yield cash | <X> | Keep unless drawdown rule triggers deployment |

## Checklist
- [ ] Execute buys
- [ ] Reserve T4 cash if not deployed
- [ ] Record actual fills in records/investment-ledger.md
```

### 7. Update the ledger after execution

When the user confirms actual trades:
- update actual shares,
- update actual execution price,
- update actual <currency>/USD amounts if tracked,
- keep planned vs actual clearly separated.

## Special Situations

### Budget changed
Scale the live ratios proportionally. Do not change the tier percentages unless the user explicitly says the portfolio policy changed elsewhere.

### Fractional shares unsupported
Round down by position and show leftover cash clearly.

### User wants to change holdings
Stop and route to:
1. `us-stock-scanner` for analysis,
2. `stock-audit` for validation,
3. only then back to this skill for execution.

## Important Rules

1. **Execution only** — this skill never changes holdings.
2. **Config-first** — never rely on stale hardcoded holdings when `portfolio-config.txt` is available.
3. **<currency>-first** — treat <currency> budget and <currency> targets as primary.
4. **Simple output** — give a buy list, not an essay.
5. **Respect live risk rules** — especially the 20% post-look-through single-stock cap and 70% tech cap from the config.
6. **No timing language** — do not frame the month as a special opportunity or danger.
7. **Always record actual fills** when the user provides them.

**Version:** 1.2
**Updated:** YYYY-MM-DD
**Frequency:** Monthly
**Companion skills:** `us-stock-scanner`, `stock-audit`
