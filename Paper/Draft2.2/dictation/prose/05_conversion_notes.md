# Conversion notes — Conclusion

Source: `05_conclusion.md`. Written into `EARNINGSRISK.tex` §Conclusion.
Compiles clean (43 pages, no errors or warnings).

---

## One passage I had to choose a reading for — please confirm

The last paragraph of your transcript contradicts itself across four lines:

> "It was really to say there's not any extra info. There's a lot of
> information available in this later analysis. There's a lot of information
> that wasn't available in the earnings profiles. That weren't allowed at the
> very end in the construction."

Two opposite readings are available:

- **(a)** Using the same variables in both stages means the later analysis has
  **no** information the profile construction did not already have.
- **(b)** The later analysis has **a lot** of information the profiles did not.

I wrote **(a)**, because it follows directly from the preceding clause ("our
choice to use the exact same variables in the construction and the later
analysis") and because it is the reading that actually answers the
over/under-fitting objection you just raised. Under (b) the paragraph argues
against itself.

This is the load-bearing sentence of that paragraph, so it is worth confirming.

## Corrected

- "The predicted values for alpha were very highly correlated **across hourly
  and annual wages**." The correlation tables report agreement **across the
  three methods within** a measure, not across the two measures. Rewritten as
  agreement among the three methods on both the hourly and the annual measure.
  As spoken it would misdescribe the table.

## Verified as spoken

0.0186; tenure as the most important variable (largest $F$ statistic *and*
largest per-variable SHAP share in all six alpha columns); the 2--5 versus 6+
ambiguity with both clearly below 0--1; the U-shape; education's significance
falling once occupation and industry enter; race mattering for transitory and
not permanent risk.

## Added

- A clause attaching tenure's claim to the evidence (largest $F$, largest SHAP
  share in every alpha specification), so the assertion is checkable in the
  text rather than only in the tables.
- "Education looks to be standing in for where people end up working" — a gloss
  on your point, not a new claim.
- **The final sentence**: "...which leaves open whether it is genuinely
  idiosyncratic or whether it is being measured too noisily here to be
  predicted." You name breaking down permanent risk as the next research
  question but never say which of these two you believe. I wrote it as an open
  question rather than picking for you. **Delete it, or replace it with your
  actual position** — this is the one spot where the paper still declines to
  take a side.

## In the results but not in the conclusion

Not mentioned in the transcript, so not written in. Flagging in case any belong:

- The models **over-sharpen** — right direction, overstated magnitude
  (predicted 3.9% bachelors+ in the top decile against 7.5% actual; predicted
  67.5% high-tenure in the bottom decile against 31.5% actual). This is the
  practical answer to "can you identify who is at risk," and it is arguably a
  headline finding.
- Occupation is highly significant as a **block** in every F test but has the
  **smallest** per-variable SHAP share in every column.
- Hourly and annual gamma disagree about education (hourly gamma rises with
  education; annual gamma has bachelors+ lowest).
- The train/test split is by person-year row rather than by person.
