---
unit: §5.1 — R-A (OLS), R-B (F-tests), R-C (Stepwise), R-D (Out-of-sample MSE),
      R-E (Prediction correlations), R-F (Occ/ind SHAP ranks), R-G (Group SHAP shares)
recorded:
status: raw — do not edit
---

<!--
Paste the raw transcript below this line. Leave it exactly as transcribed:
filler, backtracking, garbled terms, and all. Corrections happen downstream in
prose/, never here — this file is the record of what you actually said.

Talk in whatever order is natural — one continuous pass is fine, and I'll split
it across units when converting. Full question sets are in OUTLINE.md; the
headline question for each is below.

  R-A  OLS · gamma_alpha_ols.tex
       Which coefficients would you put in the abstract? Where do gamma and
       alpha disagree, and what changes when occupation and industry go in?

  R-B  F-tests · gamma_ftest.tex, alpha_ftest.tex
       Rank the nine control sets by how much you believe they matter — where
       does the table disagree with you?

  R-C  Stepwise · gamma_alpha_stepwise.tex
       What survives that you didn't expect, and how do you want to frame a
       table whose inference isn't valid?

  R-D  Out-of-sample MSE · ml_test_mse.tex          <-- the one that sets the tone
       Gamma ties the predict-the-mean baseline. Is that about gamma, or about
       your estimate of gamma? Failure or finding?

  R-E  Prediction correlations · gamma_alpha_pred_corr{,_fearn}.tex
       Methods agree on alpha, not on gamma. Independent evidence for R-D, or
       the same fact twice?

  R-F  Occ/ind SHAP ranks · *_lasso_{occ,ind}_selection.tex, *_rank_*.pdf
       Which occupations and industries top the list, and do they make sense?

  R-G  Group SHAP shares · gamma_shap_shares.tex, alpha_shap_shares.tex
       Which control set dominates for alpha? For gamma? Where do the flexible
       models disagree with the F-test ranking?

Don't describe what's in the tables — the reader can see them. Say what they
mean, and what you'd be annoyed by if a referee missed it.
-->




Okay, so moving on to the...
OLS results for alpha and gamma.
It's worth noting just what...
Which variables are significant here. So...
There it is.
Two models for each of the...
four measures essentially. One that does not include occupation.
An industry control and one that does include occupation and industry.
There is some difference as you'll see.
Throughout this, I'm in...
that interaction, that occupation, and industry control...
seem to play a role.
So we're moving them and adding them can uncover some patterns.
And we're going to turn there with how this variation looks.
So starting with gamma, it's worth mentioning.
And also, all of these coefficients.
My Yeah
The sign of the
measure doesn't matter as much or the actual magnitude.
The magnitude as much as the significance really is really the story that needs to be done.
Focus here.
Kind of important thing to take away on the gamma side is just how important.
College is so some college.
An aboutro degree are quite significant across all.
All four measures with oven.
Being significant to a p value of 0.01.
Aside from Batter's degree in the ALC.
Control's annual gamma.
And also kind of showing the variation from.
Hourly to annual earnings, the bachelor's plus is significant.
In the annual earnings situation.
In the annual earnings gamma.
Which shouldn't be that surprising as much of the kind of jobs that.
I'm going to require a job, require education beyond a bad.
I'm much more often going to be salary jobs.
If we move on to the age bins, though again you kind of see...
the pattern can be rising here so...
you have kind of the last...
age been is relatively significant aside from the all controls.
I really am. And you have the.
Earlier age bins being significant, at least in the hourly wage.
Very significant. With the annual earnings.
We want only being significant in a thirty to thirty seven range only slightly significant.
But this kind of getting back to kind of.
The.
Trend we saw before with the distribution as.
The kind of middle age age bucket here is the reference category.
And we're seeing that's, you know.
There are significance that's kind of jumping in and playing a role at the ends.
Of the distribution as far as age, so early in age.
And very late in age, there is definitely some interaction here.
Some correlation with gamma.
However, since kind of.
The. Outside of the very early age and very.
Late age it was relatively flat you don't see much correlation here with those.
Kind of age bins which is kind of consistent with that story of.
You know, game of playing a role, very early in life, very late in life.
Notably with the first age bins being significant.
For the hourly wage camera as well, I'll also tell the story a bit about this.
You know, many of the people with...
an hourly job, you're thinking maybe more people who aren't, you know.
I'm not going to college, so are jumping into a...
job earlier in life. Hence...
It would stand a reason I guess of those being routes that are significant.
Whereas the annual earnings ones you might not expect.
They're going to be a large.
Consistent store being told with people who are.
On a salary job at maybe the age of like 22 or 23.
The way you might think of someone on a salary job at that.
A H is can be quite variable.
Whereas you'd expect probably many.
22 to 25 year olds.
To be on an hourly job and maybe into their.
30s to early 30s.
Perhaps before moving to it.
A different job later.
Other than that, you don't see much that's that interesting.
Particularly, you know, tenure doesn't seem to work.
You can play a huge significant role there.
And moving to Alpha, you see kind of an interesting...
story so and for Alpha, for the hourly wage, all of the education.
Variables are significant for the annual earnings first.
You do see it matters. The battery.
The battery is the first degree in battery plus level. Which again.
Consistent with that story of annual earnings, this construction is going to be.
I skewed towards higher.
The jobs that require slightly higher level of education since most of our visa allured.
for age however you can see the last age.
It's been mattering however you only see mild significance in the very first date.
It's been 22 to 29, which is interesting.
Notably again here.
The reference category is 46 to 50.
And so for...
Many of these, particularly for like the first...
age category, you're seeing a negative value.
For all these coefficients, for alpha...
and being significant... such that...
you know, the main alpha...
should be less at this significantly less.
Then middle age, but they can't really be said for anything else other than the final age.
Which has positive values such that as a...
The order kind of group here has...
more risk... more transitory shock risk.
Then relative to middle edge from 40-60.
At least a 53. And for alpha...
These other kind of variables seem to matter quite consistently. So...
the place in the earnings percentile.
Matters. It is increasing, so risk will be increasing.
The higher up on the earnings.
The higher up on the earnings distribution you are.
And as would be expected out of the labor force is highly.
Significant in the alpha as.
You know when you're talking. Permanent income shocks versus.
Transitory income shocks much of the transitory income shocks one would be think.
Thinking about our maybe brief spells of unemployment, things like that.
So, add a labor force being very significant across all three.
It is not surprising the slightest for alpha.
Similar with tenure, you know, you're telling a similar story that...
The longer you're with the job, you'd expect the longer you're with the job, the lower risk.
You are perhaps being unemployed.
And you see that as the case here as relative to the first.
Zero to one years of tenure.
That risk is decreasing.
That the risk is less with more tenure.
however it's not necessarily an increasing amount of less risk.
But it is the case that from two to five years.
And for six plus years, that your risk is less than a...
...to you and initially just started the job. So it'd have been your first year on the job or...
...you were less than a year or unemployed that...
...your train's at a risk with a job.
Whether it's two to five years or you've been with it with six or more years that...
you have less for us for sure.
Alpha at least based on this correlation.
Which is a pattern you'd expect to be treated.
So, let's go through it. Moving on to...
To be a gamma and alpha.
F test results. This is where we kind of really want to talk about.
What?
What values are important here?
What sets of controls are important here? What type of information matters?
What type of information matters?
And so starting with the gamma.
Analysis. We can have a two kind of.
Models you have the no occupation or industry controls.
And the all controls options. And so what's going to do?
It's kind of interesting here is first.
The ones that matter in all cases, so education.
Age, cohort, and...
for the most part, census division, play a role in explaining...
this variation and...
Occupational. Occupational.
An industry play a very, very significant role as well.
When they're allowed and included. The kind of interest.
The first thing piece here and the reason why we have these two models instead of one is.
You can see that the education significance.
Drops from the first model or the second model in both.
Hourly and earnings, especially quite a bit for...
the annual earnings as it almost becomes insignificant once.
Occupation and industry controls are added in, which is an interesting kind of...
point here to make that much of the variation.
From education, as explained by...
occupation and industry.
To the point that it almost can explain how it's all the variation that there's relative.
Too little amount left over once those controls are.
Included.
And notably.
10 year not playing a massive role which is somewhat interesting 10 year.
Year fixed effects on a clear role in annual.
But tenure across all of them is not playing much of a role.
And the year fixed effects playing a role at... and the...
annual side is interesting. Just to say that...
Just here to your effects.
That's...
They seem to play a role. They seem to be explaining some variation on that.
I'm going to start with the annual earnings side, which might be a discussion around...
Just...
recessions and booms in that having...
an effect on someone maybe switching to a higher paying job.
Switching to a lower paying job such that it, you know.
Primarily affects their trajectory in a certain way.
But...
Again, this is the permanent income shock, so it's a little interesting that the year affects the effects of the...
...and it's generally relevant in the annual earnings section.
Of course, race is not important across any of them, which is...
Notable.
Moving on to Alpha.
Every single setup controls is significant.
At least to a p-value of 0.4.
1.
Big.
Kind of interesting thing at play here though is looking across the...
these two models. So you see a very similar trend as...
before with the occupation and industry controls. Explaining much of the variation.
That education was explained before so in all of in both cases.
You have education very significant for the hourly and annual earnings without.
The occupation and industry controls. And what's those occupations?
An industry control error added, you see education, significance, drop.
By large amount, the vomit's still quite significant.
You see quite a big drop there.
Age is significant across both.
Miles in both cases, same with tenure.
An interesting piece here is year fixed.
It affects with the occupation and industry controls included.
Become more significant as these Year Fix effects were at 8 o'clock.
They were so significant.
But with the occupation and industry controls.
They're even more quite significantly more significant.
And we see the cohort controls matter somewhat.
They're the least significant out of all of them, but for.
At least for that, transitory shocks are seeing a lot of just about everything significant out of something.
Moving on to the stepwise.
Results. So it's worth mentioning as mentioned before.
And this model that this model can only select the entire set of controls.
So it can either use...
So we have two models for each of the four kind of versions.
The rest measure here, so the same thing you have.
No occupation or industry control is allowed in the first one, and any of all controls allowed in the second one.
So, I'm looking at the model and just looking at the kind of check mark.
I'm just going to use here to see which sets of controls are selected.
You do see some interesting transfers.
Starting with the gamma, particularly on education, you see kind of this pattern.
So for education, for the...
hourly wage, education controls were selected across both models.
However, for the annual earnings version of gamma education.
It was selected in the first model, but once you added an occupancy.
Patient and Industry Controls, Education Controls didn't matter and they were not able to.
The patient was selected by the model even though they were allowed to be selected. They were available.
In column four.
And similar to the F.
Test table again, the year fixed effects matter for the annual earnings.
Gamma but not for the hourly earnings gamma.
Interestingly, cohort is also selected for the annual earnings.
Gamma, despite an F-test.
Cohort was select, cohort seemed to be important across hourly and annual.
Our Operators came into warning.
In both models where it could select occupation or industry, it did.
And that would be the age.
Controls were only selected. They were selected in the annual earnings.
Only in the no-control or no occupation and industry controls.
Version of the hourly gamma, which was interesting.
Again, kind of telling a story of just...
how much of that variation of occupation industry.
Really kind of explains much of the education variation.
And how much that overlap is there. As far as other variables.
The annual earnings.
Version of gamma selected all three of the continuous variables.
There are a loud in this, so it selected probably the recession.
The annual earnings percentile.
And the out of labor force. But notably hourly wage not.
Picking up any of those.
It's also worth mentioning back to the all last table, the R squared of...
these are quite low so back in the all last table.
Your r squared across gamma was 0.0.
0.0040.
0.006. It's actually only a very small amount of...
variations being explained. For alpha however, use slightly more.
Though it's still relatively low, but you have 0.022s.
0.037, 0.04, 0.04.
5.
For Alpha there's a little bit more variance being explained.
For Gamma this, you know, roughly thin amount of variation is actually the answer.
You can't blame these variables. But back to the stepwise.
So for the stepwise table, alpha.
For the alpha side of this, it selects all of the...
...continuous variables and it pretty much just selects every single...
...set of controls in every... model.
...that it can. So, every single control that's available to it, it's Alexa. Except...
for the one exception of... it does not select cohort.
In the annual earnings, no occupation.
technization of understanding the stationary
system selects every other variable it can, every set of controls possible.
In every model.
And now we move on to the machine learning methods.




So now we used to have, we've kind of covered, you know, what.
Kind of linear models can say about just.
Standard linear models what they can say about which sets of controls are important.
But now we're going to kind of look at these.
Machine learning methods to see what...
They say about which sets of controls are important.
Things such as that.
So the first kind of point you're here to make is...
Instead of a coefficient table which...
For things like random forest or neural networks.
Is not really feasible. All these compares.
Things are going to be done by ways that are comparable.
So, our three methods like mentioned before.
Neural networks, random forest.
And last so. And so starting with these first two.
We have the correlation of these predictions so.
The kind of key thing I take.
The way here is that there really is not.
Much correlation with the predicted values of.
These machine learning methods on the.
Game aside as they don't.
I agree very much on what the predictive values of a game should be.
Other than neural networks in the last, I just happened to agree somewhat.
But, as seen with like random forests...
...and their own networks or random forests and less others not...
very much agreement on productive values whereas...
on the other side, for alpha, there is quite a bit of agreement.
So, for hourly earnings for alpha.
You have correlations around .6.7.
And then for a known network in Lasso, a correlation is 0.935.
Which is quite high. Saying that like.
The predicted values of alpha. For.
The neural network and lasso methods. Agreed very very well.
And for alpha for the annual earnings you see a similar.
Story around .67.
And then neural network in LASA specifically 0.8.
Correlation.
Which is to say that there's quite a bit of a...
A decent quite a bit of agreement between Realm Network and Lasso on Alpha.
And across all three methods, there's a decent...
amount of agreement on things for alpha.
We're asking with gamma, no one ever can last so seemed up.
I have somewhat similar results however everything else.
The ear not anywhere near even being half clear.
It's correlated just anywhere from it.
Around 0.3 to 0.4.
Correlation.
For gamma, outside of neural network and lasso.
And so for...
Gama as is what's kind of the story.
With all us and stepwise. Just to say that.
You know the R squared is quite low and there's not much variation that can be.
Displaying by these variables.
And that story will be kind of...
Be a common threat throughout this.
So next we have a set of
plots here and this is again just agreement on what are the...
resciest and least risky.
Occupations and industries. So this is for gamma.
And you see... there might be...
some mild, you know, centering around this 45 degree.
I mean, four years plots, close.
Zero is zero means more risk. So.
Each point is saying across these two methods.
If we rank the rescues.
To least rescue occupations. In the top three.
Plots. How do the methods agree?
And you see some centering around that 45 degree line but...
It's not... really...
It's only mildly centered around that kind of 45...
degree line where they would be in agreement.
For industry, again, you see...
quite a bit dispersion that it's... I mean... barely.
It's not particularly even clear. It's centered around that front.
45 degree in line at all when it's ranking these.
Which is to say that, you know, for gamma...
There is not much explanatory power that... these...
you know... very little to have.
In this case specifically. And we move to the next table that...
out of sample tests, MSE. You really kind of see...
So this is done on the...
test data. So...
This is benchmarking all these methods on their test data.
So these...
methods if you predict that these methods are trained on a...
training data and then test it on a test data. So...
They're seeing observations that they didn't see within training.
And we see kind of...
across the three methods relative to this predicted tr...
which would be if you just predicted the mean...
gamma or the mean alpha from the training data.
So essentially how good are these methods doing on this new data that's...
they haven't seen compared to if they just...guest.
The main every time, what's the MSE? And...
As you'll see with gamma... If...
A model just to predict the training mean that...
All these methods are right on par with...
at... they're not able to get a mean square to error lower.
Then just predicting the training mean.
Same is true for your hourly and annual gamma that.
The predicting the mean value of.
Gamma in the training data. When.
Taken to the test data.
That these methods can't beat. Just predicting the mean.
So relative to predicting the mean they're not able to actually.
Perform at all. And we move over to out.
However, the story is different. So for Alpha...
You have a relatively low MSC, but...
As you'll see that the three methods are able to actually...
Drop the mean square there.
Buy a decent amount.
From just predicting the training mean. I mean obviously these are rough.
Small numbers but in percentage terms this is actually decent.
Drop.
So there is some explanatory power and this is kind of shown in the past with.
It's kind of the stepwise and all less tables as the R squared is.
It's quite low for alpha but it is approaching age.
You know?
Reasonable value. You're talking 5%.
You know, you're talking 0.05, 0.04.
0.02 maybe in some cases, but it's quite different.
From the R squareds on the gamma side of the OLS table, which were...
around 0.01 or 0.01.
3 or 0.06, 0.04.
So there's some variation in these alphas that can...
...and I'm not going to explain, but less so for gamma.
...and I'm not going to explain, but less so for gamma.
So...
I can move on to the table. 10 and 11. This is really kind of a noun.
We're going to move on to the F-test tables. We want to say okay across.
These methods.
What controls did?
These methods find useful.



These are obviously the shapley value.
Averaged across a set of controls.
Divided by the number of variables. So this does not allow, you know,
some sets of controls to dominate just by having more.
Variables, this divides by the number variable.
So this is the average shot value per variable within each control grid.
So how much information?
Per variable within each set of controls.
It's actually how much each one is doing in hopes to...
normalize and really see which is...
which set of controls is contributing the most. So this is for Alpha specifically.
And...
We see the...
largest.
10 year as
10 year plays quite a large role in both.
Requested o
three models. 10 year is the a
share.
S
in.
After 10 years, there are some kind of...
separation across hourly wage and annual earnings.
So after 10 year in the hourly wage side.
age...
from the and sense of physician death was in
and race.
play a modest role and...
industry.
So on the early wage side.
Census division.
trace an edge play a roll.
Where control is like an industry.
And cohort.
Play a modest role. On the annual earnings.
After 10 year.
There's some disagreement about what.
Control is play the largest.
So across all three methods age.
Please a roll.
On the neural network side, education played a quite large role.
However, Ollie had a modest role in random forest in last year.
It was an industry across all three.
Played a modest role.
Cohort played a modest role except for Lassa.
And across all three race played a large one.
The role and census of reasonable. Amount of variation was.
Explained for census division.
which is to say that across both measures, census, division.
Industry and age.
As well as race seem to be quite an...
...important. Along with tenure which is the most...
important variable across both versions of Alpha.










