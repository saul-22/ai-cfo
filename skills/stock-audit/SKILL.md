---
name: stock-audit
description: Use when validating a proposed stock addition, swap, or portfolio change before updating the live investment plan, especially when checking overlap, concentration, and current portfolio-rule compliance.
---

# Stock Audit

## Overview

This skill is the validation gate before a holding change. It reviews a proposed stock, ETF, or swap and returns a structured verdict.

**Non-negotiable boundaries:**
- This skill validates; it does not execute monthly buys.
- This skill never edits `portfolio-config.txt`.
- In a small portfolio, overlap and concentration matter more than finding a "good story."

## Persistent Files

**All files are in:** `./investment/`

| File | Purpose | Access |
|------|---------|--------|
| `portfolio-config.txt` | Canonical holdings, tier targets, limits | **READ only** |
| `records/investment-ledger.md` | Actual purchase history | **READ only** |
| `records/scan-history.md` | Prior scan and audit context | **READ + WRITE** |

## When to Use

**Use for:**
- "Audit this stock"
- "Validate this swap"
- "Should this replace one of my holdings?"
- "Double-check this portfolio change"
- any request to approve or reject a holding change before it is written into the live plan

**Do not use for:**
- monthly execution,
- routine budget scaling,
- quarterly broad market discovery without a specific proposed change.

Use `monthly-portfolio-plan` for execution and `us-stock-scanner` for broader scanning.

## Canonical Portfolio Source

Always read:

```text
./investment/portfolio-config.txt
```

Use it as the live authority for:
- current holdings,
- 40/30/20/10 allocation,
- 20% post-look-through single-stock cap,
- 70% tech exposure cap,
- emergency drawdown wording.

## Audit Workflow

### 1. Understand the request type

Common request types:
1. Single-stock audit
2. ETF audit
3. One-for-one swap validation
4. Full portfolio change review

### 2. Check historical behavior

For each proposed holding, gather:
- 1-year return
- 3-year annualized return
- 5-year annualized return when available
- maximum drawdown
- behavior versus relevant benchmark or peers

Use history as context, not as an automatic buy signal.

### 3. Check fundamentals or ETF quality

For individual stocks, review:
- revenue trend,
- earnings trend,
- free cash flow or profitability path,
- debt burden,
- competitive position.

For ETFs, review:
- expense ratio,
- AUM and liquidity,
- index construction,
- overlap with current direct holdings and ETFs.

### 4. Run overlap and concentration checks

This is the most important section for this portfolio.

#### A. Overlap
- Does the proposal duplicate exposure already owned through a broad-market ETF or another direct holding?
- Does it add distinct exposure, or just more of the same theme?

#### B. Single-stock concentration
Use the live rule from `portfolio-config.txt`:
- **Pass:** post-look-through exposure remains below the live single-stock cap
- **Conditional:** approaches the cap and clearly reduces future flexibility
- **Fail:** exceeds the live single-stock cap

Examples using the current framework:
- Adding a name that pushes look-through exposure above the live cap = **FAIL**
- Replacing a name with another that keeps several positions clustered near the cap = usually **CONDITIONAL** or **FAIL**

#### C. Sector concentration
Use the live rule from `portfolio-config.txt`:
- **Pass:** total sector exposure stays below the live sector cap
- **Conditional:** near the cap with weak diversification benefit
- **Fail:** exceeds the live cap

#### D. Correlation and slot value
In a small-position portfolio, redundancy is expensive. A new holding must justify its slot.

### 5. Check entry context

Review:
- price relative to 52-week high,
- current valuation versus its own history,
- whether any major drawdown reflects a broken thesis.

This is a warning layer, not a market-timing system.

### 6. For swaps, compare old vs new directly

Answer:
1. Does the new holding improve diversification, quality, or return potential?
2. Does it reduce overlap or concentration risk?
3. Is there a forward-looking reason for the change?
4. Does the switch still fit the tier role in the current portfolio?

A swap should fail if it mainly replaces one concentrated exposure with another.

## Verdict Framework

```markdown
## Audit Result: [TICKER or SWAP]

**Verdict:** ✅ PASS / ⚠️ CONDITIONAL PASS / ❌ FAIL

### Scorecard
| Dimension | Score | Details |
|-----------|-------|---------|
| Historical Performance | ✅/⚠️/❌ | ... |
| Fundamentals / ETF Quality | ✅/⚠️/❌ | ... |
| Overlap & Concentration | ✅/⚠️/❌ | ... |
| Entry Context | ✅/⚠️/❌ | ... |
| Swap Logic | ✅/⚠️/❌/N/A | ... |

### Summary
[2-3 short sentences]

### Conditions
- [Only if applicable]
```

### Verdict rules
- **PASS**: no material conflict with the live portfolio rules
- **CONDITIONAL PASS**: acceptable only with specific limits or a narrow use case
- **FAIL**: breaches live concentration rules, creates clear redundancy, or weakens the tier role
- **Overlap & Concentration = ❌** should normally make the whole audit **FAIL** in this portfolio

## Batch Audit Output

For multi-holding reviews, include:
- each ticker verdict,
- resulting sector exposure,
- highest post-look-through single-stock exposure,
- whether the full set still fits the live tier ratios,
- whether any proposed change requires a different hedge or cash response.

## Integration Rules

- `us-stock-scanner` may propose changes.
- `stock-audit` validates the proposal.
- `monthly-portfolio-plan` executes only after the final holdings are settled.

## Important Rules

1. **Validation only** — this skill never edits `portfolio-config.txt`.
2. **Use live limits** — single-stock cap and sector cap as defined in `portfolio-config.txt`.
3. **Bias toward no change** — the burden of proof is on the new idea.
4. **Prefer clarity over precision theater** — strong reasoning beats false exactness.
5. **Document conclusions** in `records/scan-history.md` when they matter for future decisions.
6. **Do not keep stale examples** that imply old holdings or looser rules.

**Version:** 1.1
**Updated:** YYYY-MM-DD
**Frequency:** On demand
**Companion skills:** `us-stock-scanner`, `monthly-portfolio-plan`
