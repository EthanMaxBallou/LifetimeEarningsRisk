---
unit: F-E (Conclusion) — then F-D (Introduction) and F-F (Abstract) after
recorded:
status: raw — do not edit
---

<!--
Paste the raw transcript below this line. Leave it exactly as transcribed.

Findings below are what the written sections actually support, with the numbers
already verified. Talk against them; don't recite them. The conclusion needs
your judgment, not a second pass through the tables.


=====================================================================
THE SPINE — if the conclusion says one thing, this is it
=====================================================================

  Transitory earnings risk is predictable from observable characteristics.
  Permanent earnings risk is not.

  Evidence, three independent ways:
   - Out of sample, no method beats predicting the training mean for gamma, on
     either measure. All three beat it for alpha (2-4 percent lower MSE).
   - In-sample R-squared: gamma 0.001-0.006, alpha 0.022-0.052.
   - The methods agree with each other about alpha (0.60-0.93) and not about
     gamma (0.28-0.39, except NN/LASSO). The neural network gives up on gamma
     entirely and predicts 0.0186 for essentially everyone.

  Say what you think this MEANS. Is permanent risk genuinely idiosyncratic --
  the thing you cannot see coming, by definition -- or is the constructed gamma
  too noisy to predict? Both are defensible; the paper currently takes no
  position, and the conclusion is where one is expected.


=====================================================================
WHAT PREDICTS TRANSITORY RISK
=====================================================================

  1. TENURE, and it is not close.
     - Largest F statistic in every alpha column (42.69 / 22.38 / 88.12 /
       36.00; nothing else exceeds 17).
     - Largest SHAP share in every column and every method; random forest puts
       it at 0.5417 hourly and 0.4900 annual against nothing else above 0.035.
     - Monotone decline in the raw data across all four measures.
     - Caveat you should state once: unemployed are assigned to the 0-1 bin, so
       this is partly a statement about unemployment.

  2. AGE, U-shaped over the career.
     - Elevated early, flat mid-career, rising sharply late. Alpha hourly runs
       0.0929 at 22-29, ~0.087 through mid-career, 0.1585 at 62-69.
     - OLS finds significance at the ends and not the middle (46-53 is the
       reference), which matches.
     - The 62-69 bin has only 1,252 observations.

  3. EDUCATION, declining, and it is largely occupation and industry.
     - Alpha falls with education on both measures.
     - Education's F statistic drops sharply once occupation and industry enter
       (alpha: 9.48 to 6.79 hourly, 17.10 to 9.73 annual; gamma annual: 3.57 to
       2.13, barely significant). Stepwise drops education entirely from annual
       gamma once occupation and industry are available.
     - So education is largely a proxy for where people work.

  4. RACE matters for alpha and not for gamma.
     - Race is insignificant in all four gamma F tests and significant at
       p<0.01 in all four alpha F tests.


=====================================================================
FINDINGS ABOUT METHOD
=====================================================================

  5. THE ML METHODS RECOVER SOMETHING OLS MISSED.
     OLS says both higher tenure bins carry less risk than 0-1, but in three of
     four specifications the 2-5 bin sits BELOW the 6+ bin, so OLS never
     delivers a clean monotone decline. All three ML methods do. This is the
     concrete payoff of the flexible methods and probably your best
     methodological point.

  6. F TESTS AND SHAP DISAGREE ABOUT OCCUPATION.
     Occupation is highly significant as a block in every F test, and it has
     the SMALLEST per-variable SHAP share in every column. Both are true: it
     matters in aggregate and almost nothing per category. Worth naming.

  7. THE MODELS OVER-SHARPEN.
     They get the direction right and the magnitude wrong, consistently:
       - top decile bachelors+: predicted 3.9%, actual 7.5%
       - top decile low tenure: predicted 72.8%, actual 59.3%
       - bottom decile high tenure: predicted 67.5%, actual 31.5%
       - bottom decile white: predicted 81.1%, actual 61.7%
     The honest read: a characteristics-based ranking finds roughly the right
     people, but it believes in the pattern more than the data does.

  8. THE GAMMA TAILS ARE NOT CHARACTERIZABLE.
     Top and bottom gamma deciles look like each other and like the sample:
     57.1% and 51.7% in the 0-1 tenure bin against 45.0% overall. Consistent
     with the spine.


=====================================================================
HOURLY VS ANNUAL
=====================================================================

  - Annual risk is uniformly higher than hourly, for both measures, at every
    education level.
  - Alpha behaves the same way on both. Gamma does not: hourly gamma RISES with
    education (high school graduate lowest at 0.0148), annual gamma has
    bachelors+ lowest (0.0236). The two measures disagree about permanent risk
    and education because the job distributions behind them differ.
  - Year fixed effects matter for annual gamma and not hourly.


=====================================================================
WHAT TO CONCEDE
=====================================================================

  - Even where prediction works, explained variation is small (alpha R-squared
    tops out at 0.052).
  - Gamma and alpha are estimates used as dependent variables.
  - Descriptive, not causal -- and you already say so in the empirical strategy.
  - The train/test split is by person-year row, not by person, so the same
    individual appears in both. Decide whether to concede it or fix it.


=====================================================================
FORWARD
=====================================================================

  - What would distinguish "permanent risk is idiosyncratic" from "our gamma is
    too noisy"? Is any of it feasible?
  - What does the asymmetry imply for consumption and savings models, which
    typically treat permanent risk as the one that matters?
  - If transitory risk is largely tenure and job position, is that insurable in
    a way permanent risk is not?
  - What is the next paper?
-->


Okay, so the main findings of these...
of this paper is that, you know, we've kind of gone on this...
discussion about constructing these gamma and alpha statistics...
...as measures of risk and...
Now after this further analysis...
A few things can be said, so...
The transitory risk is predictable from the...
... preservables throughout much less analysis.
while it still is a relatively low R squared.
Alpha is able to be predicted.
At least somewhat based on these methods even.
All while less. Whereas permanent risk.
Is not as predictable really.
Particularly for the machine learning methods not being able to beat that.
Training data mean really kind of goes to sh-
so that, you know, even-
these really powerful methods aren't able to pick up-
on very many patterns in the permanent risk.
Since it's further shown in the stratified...
...predicted values as for gamma, it's...
almost just guessing randomly on the gamma side.
And just picking, you know, slight variations from the mean.
Gamma, basically.
Particularly the neural network.
Almost gives up and just predicts the 0.0.
1.8.6 for almost everybody.
However, within transitory risk, there are some patterns that arose.
Specifically tenure in...
All the methods agreed that for transitory tenure mattered.
Quite a bit. It might have been the most important variable.
In many cases. In that...
You have, you know, decreasing train of...
the higher tenure you go, well...
OLS didn't quite support this 100%
The consensus from the machine learning methods really pushed
that and it may be ambiguous whether it's...
...truly decreasing with a higher tenure but it's...
clear that...
while it might not be clear whether...
2.5 or the 2 to 5 tenure bin.
is more or less risk than the...
six or more years been... it is clear that there...
both far lower in risk than the zero on one bin.
Also, within transitory risk you do get...
the U-shaped pattern as...
shown in just about all the machine learning methods that you have.
I have kind of some elevated...
risk early, your mid-career is relatively flat and then...
you have a sharp rise later in life with... when you have...
approaching retirement.
Particularly with education was the interest...
...and the interesting one as education and occupation...
...the American industry seemed to share much of the same variation... ...while they both...
...mattered occupation and industry...
...many times mattered much more.
...and education, which is an interesting finding.
...and also...
...so many of the test race seem to matter for the transverse shocks.
...but these amount as well.
As far as methods, you know, we kind of...
contribution of this paper is really in the special methods.
It's used to kind of try to recover patterns in the data that all of us can't see.
And in this sense...
These machine learning methods were... Able to agree...
Many times actually... quite well...
when it came to predicting the transitory shocks that they...
found very similar patterns and had quite a bit of agreement as...
discussed in like the correlation of the predicted values in that...
the predicted values for alpha were very highly correlated.
Across hourly and annual wages.
In order to produce this is
Yeah this could be taken, you know.
Both ways, it's not to say. Definitely not making any causal claim.
Here, as it still is strictly a correlation study, but...
it is to point out that these methods with allowing...
for the kind of interdependencies that they do, were able to...
go beyond what the kind of...
regular linear models could pick up on.
And we were able to...
show some of those patterns throughout this analysis.
I think further...
point of research in this field would definitely be...
breaking down this permanent income risk.
The one kind of...
...tradoff with...
...doing a research project like this is that...
...on some level our construction of...
...these measures has an impact...
...on the later analysis...so how well we constructed...
...the earnings profiles initially to construct...
...these risk measures.
...is gonna have some effect on the... ...laser.
...and one can make the argument that...
...we...
...have overfitted the earnings profiles in the initial construction.
And therefore are leaving out variation that...
should have been predictable. Or it should have been useful in predicting later.
And someone also could make the argument that we have under-
fitted. And that-
Lots of the results we have in this analysis section.
Are really just the result of under fitting the...
earnings profiles construction initially however...
our choice to use the exact same variables
and the construction and the later analysis.
It was really to say there's not any extra info.
There's a lot of information available in this later analysis.
There's a lot of information that wasn't available in the earnings profiles.
That weren't allowed at the very end in the construction.
Section.
