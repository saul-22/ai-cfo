# Stock Evaluation Criteria Reference

## Portfolio Context

Use `./investment/portfolio-config.txt` as the only live truth source.

Current live structure:
- **T1 Core:** 见 `portfolio-config.txt`
- **T2 Growth:** 见 `portfolio-config.txt`
- **T3 Hedge:** 见 `portfolio-config.txt`
- **T4 Cash:** 见 `portfolio-config.txt`

Target allocation 由 `portfolio-config.txt` 定义。

---

## T1 Core - Selection Criteria

T1 is reserved for the most durable core exposure in the system.

| Criteria | Threshold | Why |
|----------|-----------|-----|
| Role fit | Core index or category leader | T1 should anchor the portfolio |
| Scale | Very large, durable business or broad ETF | Reduces fragility |
| Revenue / earnings quality | Stable to strong | T1 should not depend on perfect conditions |
| Competitive position | Category leader or dominant platform | Core slots must have staying power |
| Drawdown tolerance | Must be survivable in a long-term DCA plan | Core should not become a forced exit |
| Overlap impact | Must still respect live concentration rules | Core cannot break the system |

**Current T1:** 见 `portfolio-config.txt`

**T1 note:** direct and ETF look-through exposure must still keep any single stock below the live single-stock cap.

---

## T2 Growth - Selection Criteria

T2 is for proven growth names that add return potential without breaking diversification.

| Criteria | Threshold | Why |
|----------|-----------|-----|
| Market Cap | Usually large-cap or upper mid-cap | Big enough to be durable |
| Revenue Growth | Prefer >10-15% YoY | Growth must be real |
| Profitability | Profitable or highly credible cash-flow path | Avoid weak stories |
| Competitive position | Clear moat, scale edge, or leadership | T2 slots must earn their place |
| Diversification effect | Should not just duplicate existing tech exposure | Slot value matters |
| Institutional quality | Positive institutional support preferred | Helps filter weak narratives |

**Current T2:** 见 `portfolio-config.txt`

**T2 note:** at least one T2 position should provide genuine non-tech diversification or lower correlation to the main tech cluster.

---

## T3 Hedge - Selection Criteria

T3 exists to diversify the portfolio, not to add another growth bet by default.

| Criteria | Threshold | Why |
|----------|-----------|-----|
| Role fit | Real hedge or low-correlation diversifier | T3 must offset equity concentration |
| Correlation | Meaningfully lower than core tech holdings | Otherwise it is not a hedge |
| Liquidity / simplicity | Easy to hold and understand | Hedge sleeve should stay maintainable |
| Portfolio impact | Improves drawdown behavior | T3 earns its slot through diversification |
| Rule compatibility | Must not push tech exposure higher | Hedge sleeve should reduce concentration, not add to it |

**Current T3:** 见 `portfolio-config.txt`

**T3 note:** do not assume a satellite growth stock belongs here. Under the current framework, T3 is a hedge sleeve.

---

## Red Flags - Immediate Review Triggers

Any of these should trigger review or audit:

1. **Financial / thesis break**
   - Revenue decline or clear deceleration with broken thesis
   - Earnings deterioration with no credible recovery path
   - Guidance cut that changes the investment case

2. **Governance / integrity**
   - SEC investigation
   - Accounting issues or restatement
   - CEO departure tied to strategic instability

3. **Competitive deterioration**
   - Meaningful market-share loss
   - Core moat weakening
   - New evidence that the business is becoming replaceable

4. **Portfolio-rule breach**
   - Post-look-through single-stock exposure approaching or exceeding the live single-stock cap
   - Total sector exposure approaching or exceeding the live sector cap
   - Hedge sleeve no longer behaving like a hedge

5. **Drawdown trigger**
   - Any single stock down 40%+ in a quarter

---

## Green Flags - Confidence Boosters

These strengthen the case for holding or considering a stock:

1. Revenue beat plus raised guidance
2. Expanding margins or stronger cash generation
3. Institutional accumulation
4. Competitive position strengthening
5. Outperformance versus peers without obvious multiple mania
6. Diversification benefit that improves the whole portfolio, not just the single idea
