# Rebalancing Rules Reference

## Annual Rebalance Protocol

Every 12 months, or when the live rules are triggered, rebalance toward the target allocation in `portfolio-config.txt`.

### Target Ratios
- T1 Core: <X>%
- T2 Growth: <X>%
- T3 Hedge: <X>%
- T4 Cash: <X>%

> 实际比例从 `portfolio-config.txt` 读取。

### Preferred rebalance logic

1. Calculate current portfolio weights.
2. Compare them with the live targets.
3. If a holding or tier is modestly off target, prefer correction with new money.
4. If a holding or tier is materially off target, review whether a direct rebalance is needed.

### Trigger levels from the live framework

| Trigger | Action |
|--------|--------|
| Any holding or tier deviates by ±5 percentage points | Correct with next-month incremental buys |
| Any holding or tier deviates by ±10 percentage points | Annual rebalance can use direct sells/buys |
| Sector exposure exceeds the live cap | Redirect new money toward non-sector holdings until exposure is back under control |

### Example

Total portfolio value: 100,000 <currency> equivalent

| Tier | Target % | Target Value | Current Value | Current % | Action |
|------|----------|--------------|---------------|-----------|--------|
| T1 | <X>% | ... | ... | ... | ... |
| T2 | <X>% | ... | ... | ... | ... |
| T3 | <X>% | ... | ... | ... | ... |
| T4 | <X>% | ... | ... | ... | ... |

---

## Stock Replacement Rules

### When to Replace

A holding should be reviewed for replacement only when at least one of these is true:

1. **Fundamental break**
   - Core thesis is damaged
   - Competitive advantage is weakening materially
   - Governance failure changes trust in the business

2. **Sustained deterioration**
   - Underperformance is tied to weaker fundamentals, not just volatility
   - Better replacement candidates clearly improve diversification or quality

3. **Portfolio-rule conflict**
   - Post-look-through single-stock exposure breaches the live single-stock cap
   - Total sector exposure breaches the live sector cap
   - The holding creates avoidable redundancy in a small portfolio

### When NOT to Replace

- Price fell but the thesis is intact
- The holding is merely boring
- A hotter narrative appears with no portfolio benefit
- Broad market weakness is affecting everything

### Replacement process

1. Flag the issue in `us-stock-scanner`
2. Validate the proposed change in `stock-audit`
3. If approved, update `portfolio-config.txt`
4. Execute the revised holdings through `monthly-portfolio-plan`

---

## Drawdown Response Protocol

Use the live drawdown language from `portfolio-config.txt`.

| Market Drop | Action | Details |
|-------------|--------|---------|
| 0-20% | Normal plan | Continue monthly DCA as planned |
| >20% | Evaluate deploying T4 cash into T1 | Keep response tied to the live portfolio rules |
| >30% | Pause new T3 buying, redirect that month's T3 funds into T1 | Use only if the live rule is triggered |

**Rules:**
- Prefer deploying into T1 when the live drawdown rules call for action.
- Rebuild cash through future monthly contributions.
- Do not rewrite the whole portfolio during a drawdown unless a thesis actually breaks.
- Use the broad market drawdown from recent highs as the reference, consistent with `portfolio-config.txt`.

---

## Tax and Execution Notes

- Prefer incremental rebalancing before selling in taxable accounts.
- If selling is necessary, note possible tax impact and holding period.
- Keep monthly execution and quarterly review as separate steps.
