---
unit: §5.2 — R-H (Predicted means by group), R-I (Education x age matrices),
      R-J (Top and bottom risk deciles)
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

  R-H  Predicted means by group · gamma_alpha_pred_means{,_fearn}.tex
       Do the models reproduce the raw stratified means from the data section?
       Where do they miss, and where do the three methods disagree?

  R-I  Education x age bin matrices · {gamma,alpha}{,_fearn}_pred_matrix_*.tex
       Does risk fall with education at every age, or is there a real
       interaction? Which one or two of the four sets earn body space?

  R-J  Top and bottom risk deciles · gamma_deciles.tex, alpha_deciles.tex
       Describe the person in the top decile, then the bottom, in plain
       language. For alpha: does the predicted ranking find the SAME PEOPLE as
       the actual ranking? That's the practical payoff of the whole paper.

This section is the one a non-specialist reader will remember, so plain
description of who these people are matters more here than anywhere else.

Two things to settle while talking:
  - Gamma is sorted by actual risk only, alpha both ways. Explain that
    asymmetry the way you'd say it to a skeptical referee.
  - Deciles are computed within age bin. Why, and what goes wrong otherwise?
-->



Okay, so moving on to the...
mean predictions of gamma and alpha.
With Table 11.
We can kind of see the truth.
The trend of how these controls play a role. So...
education being the more interesting story here. So...
This is hourly earnings and...
aside from the bachelor's plus category.
All three methods predict decreasing risk.
Get an alpha, so decreasing.
And then, you can see the values of alpha as with more education.
However, they do project that.
The bachelor's plus category does rise relative to bachelor's degree.
Across all three methods.
Which is a consistent pattern for alpha.
Across the actual.
Average value. Of. Alpha across.
Education so. You have.
You have risk transitory shock risk being highest.
At less than high school than you have it decreasing until you hit.
The bachelor's plus, where you see a slight increase.
But it's still less risk than.
Some college and that claim is true across the actual and across the...
all three methods. For the game aside...
you really start to see the key.
Lack of ability to predict.
Much of the variation you have.
For the actual values you have a slight decrease from less than high school to.
High school graduate and then you have it rising through summer.
I'm going to call it a bachelor's degree and then a drop for bachelor's plus.
And none of these methods are really able to capture that pattern.
In the drop.
Then rise of gamma, then slight drop at the end.
And you really see it with the neural network.
This predicting 0.0186 across every...
value of education. Really...
It's kind of demonstrating how little variation is out there to be described by.
Gamma with these variables.
And this is true across much of this tape.
So, we're going to go on the gamma side. So.
None of these methods really line up with
the actual patterns. Just take a...
the actual column here is just... if you just take the...
a mean value.
And this is tables, just the stratified means that the patterns kind of...
in the ups and downs of the stratified means none of the three methods are...
...really able to pick up on these patterns within each...
...a set of controls.
However, going back to that...
Alpha side.
Looking at the age bends.
You do see quite a bit of agreement across all three with it.
The actual pattern in the alpha.
So you do see for the most part.
From 22 to 29 you have a relatively...
high value, then you see a drop.
Staying around zero point.
085 to 0.087.
For the next three bins from 32.53.
And then 54 to 61 all of the methods.
Show a jump. And then.
All the methods for 62 to 69 show a large jump again.
Which is consistent with the pattern that...
...alpha has in general.
And if we move on a 10 year...
for Alpha, this is really the one that's shown me most important.
For the group shares and...
even going back all the way to the F test results... you saw...
that the...
test statistic was exceptionally high for tenure across alpha.
And...
This is consistent here as
10 year in the actual values this is going to be dropping off.
With our tenure and you see that pattern show up in the...
all three methods. And this is a really important point.
To notice here that these methods were able to pick up on this downward trend.
However, that was something that...
...or less wasn't quite able to do.
That's...
The OLS models that we ran.
Understood that, you know, relative to the...
First, 10-year-bin of 01.
The next two...
10-year bins of 2-5 and 6 or more.
Add lower amounts of transitory shock risk.
However, there wasn't necessarily agreement.
That transitory shock risk was decreasing the tenure.
As for some of the models.
The two to five year bin actually had.
Less risk than the six or more years been.
And this is kind of getting at that idea of, you know,
all three of these methods capitalized on this.
Downward Sloping Trend and in the data you see that downward sloping trend.
That this risk is decreasing.
Decreasing in 10 year and...
These machine learning methods.
We're able to capitalize on that whereas just standard OLS.
It wasn't really able to highlight that trend.
Cleaner way.
And if we move on to annual earnings.
The same is true of tenure as in the true data.
You have this downward trend and all three methods are able to cap the...
...make sure that downward trend.
In addition, the age bends...
...tell a similar story on Alpha.
In the annual earnings side.
As well as the education.
Tying a pretty consistent story.
And again, on the gamma side for this annual earnings table.
You can't really see very many patterns that these methods are able to pick up on.
That are consistent with the actual data here.
Now I'm moving on to the
main predicted alpha by education.
This is really kind of where you see who.
It has the highest risk across these levels of education across the...
their lifetime. And this is really looking at this for Alpha since...
Gamma, there really isn't much explanatory power there.
I mean, those tables will be in appendix, but...
There isn't much of their...
There aren't really very many trends that...
these methods are able to pick up with four...
Pick up on four...
r
So starting with hourly earnings for table.
For most of these trends.
Across the actual values and across the three methods.
You see a relatively common pattern of starting at some.
Value in the 22 to 29 age of n. And then.
The value drops remains relatively steady.
From 30 to 53. And then you see a rise.
From the 54 to 61 and 62 to 69 age groups.
And the vast majority of methods.
Agree relatively well on this.
The kind of interesting thing here is...
when this kind of larger spike at the end of the life.
comes about. So...
In the actual... Alph.
For values. You see...
The large end of life kind of spike.
Our end of career spike really happened at the 62 to 60.
I'm age Ben.
And it's only for some college or bachelor's plus.
You see the spike in the 54 to 61 inch bend.
And.


And most of the methods capture this.
And looking at the annual earnings.
Versions of these tables.
For Alpha.

You see kind of a similar pattern.
With a slight drop and risk.
At the beginning and then a jump towards the end of life.
However, for...
The Bachelor's Degree and Bachelor's Plus.
For the actual values, you almost see just a st-
study rise in risk of transit-
when lifeMON guardian
and most of the most of the methods disagree with this most of the method
that's think you have
risk at the first age been
and then you have a drop in
transitory shock risk.
And then a spike towards the end of the life.
However, compared to the mean actual values, you don't...
see that trend for bachelor's degree or bachelor's plus.
But for the most part other than that, you see relatively similar...
...patterns across all three methods and the actual values.
And finally we reach V.
Last couple tables. So table.
With the characteristics of the.
Top and bottom risk deciles.
Grouped by age.
Starting with Gamma. This table only has the average.
The actual Gamma statistic instead of the predicted values.
Since as we've kind of seen...
There isn't much that these methods can really...
do to explain the variation in gamma using these variables.
So when trying to characterize who has the most risk, we'll strictly...
mostly be looking at just... average.
Values of just the gamma statistic for gamma.
However, later for alpha...
...and the next table, we'll look at the predictions as well.
And those will be the mean predictions across the three methods.
But, starting with gamma, we've got the same
kind of established.
Some of these kind of trend before, but looking at...
We have this split into three kind of groups, so we have ages 22 to 33.
34 to 57 and 58 to 69.
This is to really get at that.
Kind of trend we've been seeing in all of these across Gamma and all of that.
You have some kind of interaction happening at the beginning of life.
At the beginning of a person's career, then often you have kind of a...
steady kind of level mid-career and then once you get...
closer retirement those last kind of two age bins you see a lot of kind of stuff.
going on so this breaks it out into those three.
Age groups and then we're looking at the top 10%.
Riskiest people in the bottom 10% riskiest people.
And what shares of them have these characteristics.
So, for hourly wage.
The kind of age group.
We're probably the most interested in for hourly wage annings.
It's probably the middle age age group.
The reason these other two age groups on the ends are really broken out is...
strictly adjust so that we can kind of get a look.
At this middle age group where there's lots of more interaction.
So like the age group at the end of their life probably has a lot to do with...
just things like preferences around a person's retirement.
Things like that. And the first kind of age group is...
Probably a lot more variable to where individuals from may...
Maybe characteristics of...maybe there are...
high school experience or whether they're parents.
The level of education of their parents, things like that. I mean, some of those people are...
You have selection in some sense of something born college, maybe you don't have a job.
And aren't in this data yet. But that middle-aged group is really where you think.
Okay, we're gonna have just about everyone in the-
population in this middle-aged group, and this is where most of people's careers-
goes on, so looking at that middle-aged group.
First for Gamma.
Hourly wage side for education.
You don't see very many trends that much.
The one kind of notable thing being that with people with less than high school...
experience you do see...
...this will be larger share in the bottom 10%.

An interesting interaction here is...
the tenure bends.
In this center age group.
You see relatively high shares of.
People in both bins.
In both the top and lowest tempers.
In the top 10% of people as far as risk. That it doesn't seem clear.
That you know people with.
Lower tenure.
Are often among the bottom 10%.
Or the top 10% of our risk to these permanent income shocks.
You see 57.1% of people in the bottom.
10% are in this 01 tenure bin.
51.7% are in this 01 tenure bin.
of the people in the top 10% riskiest for.
Against riskiest people for these permanent income shocks.
The 51.7% of them are in the 01 10 year bin.
Realtor two...
The whole sample only 45% of people.
are in that 01 10 year bin, which is quite interesting.
Um...
There doesn't seem to be much.
Correlation with persons risk to permanent income shocks.
And tenure in this case.

And across much of the other.
Variables. You can't tell a time.
Moving on to annual earnings however.
Moving on to annual earnings.
You have a similar...
There's somewhat of a similar kind of trend going on here and that...
It's not clear.
That the people in the bottom 10% or the top 10% have...
a... different...
I've clearly have different characteristics. The characteristics seem real...
...to be on par with much of...
...the rest of the sample.
There's not a time to be set there.
moving on to table sixteen now for alpha
here we have the predictions
with included here so we have the total for all of
them the entire sample then you have the prediction for the bottom 10%
prediction for the top 10%
and the actual for the top 10% and the...
The idea is, are there any patterns we can pick up on here? And this...
with Alpha being able to be more explained by...




so for the hourly wage alpha this is where the predict
kind of try to pick up on a pattern which is kind of interesting here
so looking at the center of age band across education
these models predict...
...that in the top 10% riskiest that you have...
...a decent amount of less than high school and high school graduates.
And you have relatively few people with at least some college.
Bachelor's degree or bachelor's plus. In fact it.
Under predicts it believes that. The top.
10% risk is people there. The majority of them are less.
In this case,
and for the bottom 10 percent, the people...
least exposed.
To this transitory income shock risk.
It attributes a much higher...
Predicted share of people with bachelor's plus
bachelor's degree or some college.
Relative to the actual its predict...
...using much more people would be in the bottom 10% of risk with...
...some college bachelor's degree or bachelor's plus. And...
This trend is...not...
...the clearest.
...when it comes to the actual predictive...
...the actual predictive...
...the actual values just computed as means.
So in the top 10%, it does a lot of people in the top 10%.
Just computing the meme based on their...
Based on their actual alpha value.
There is quite a few of them who are just high school graduates. But...
It still puts... 14% of those people have like a bachelor's degree.
Whereas the models predict that 7.5%
of the people in the top 10% should have a bachelor's degree.
And the actual value for bachelor's plus in the top 10%.
Is 7.5% whereas the predicted measure for the top 10 risk.
Yes should be 3.9% for Batch Risk Plus.
So the model predicts that the top 10% risk is people.
That 4% of them, only 4%...
...should have bachelors plus whereas the actual...
...calculated alpha based on the data shows.
It should be 7.5%
Which is to say that these models are...
kind of predicting this kind of...
From the top 10% riskiest, most...
...these people, it should be heavily skewed towards lower education.
And that the bottom ten least riskiest should be heavily skewed towards...
...higher education in this trend.
represented by photograph.
similar
will you see somewhat similar
story which is somewhat consistent
with well it actually isn't
that consistent with the actual data.
Oftentimes, so for tenure...
looking at the top 10% riskiest individuals
so these transitory shocks, the predicted...
values say that 73% of those people should have...
...of tenure between 0 and 1 for the top 10% risk is.
And that it should be relatively low for the other two tenure bins, so 11.4%.
So that much of the top 10%.
Riskiest people should be heavily dominated by that 01.
Whereas it's saying for the least riskiest people on the bottom 10%
that that should be heavily dominated by people with six
or more years of tenure or people with two to f-
five years of tenure but only 11.1% of those people.
Should have zero to one year of tenure.
And this is a clear pattern showing up for the predictions.
Isn't totally consistent on the actual values.
Though it's somewhat consistent that the top 10% riskiest.
59.3% of them are in the 01. So...
the largest 10-year bin for the top 10% risk is...
...is dominated by people in that zero one bin. However, it's not...
as severe as the models predict. As the models predict, it should be more like...
73%. And when you get...
to the bottom 10% the... based on just...
actual calculated alpha values you get...
only 32% of people in that bottom 10%.
are in the six or more years of 10 year versus the predicted.
And you still have...
28% of people in that bottom 10% tier.
Of risk that are in that 01 10 year bin, which is...
It's kind of a clear...
a clear pattern in that sense.
moving on to the other variable
so here so
If we move to the annual earnings side of the _____ _____ _____ _____ _____ _____ _____
you'll see the same pattern showing up that
the top 10% riskiest people, the models.
For the center age group again, the top 10% riskiest people.
Quite a bit of people.
You still have like 17%
of less than high school whereas the model predicts only 8% of people.
In that bottom 10% risk level shit.
Have less than high school.
And for the top 10% riskiest you see...
14% with some...
percent. So while the model seems to.
Clearly want to say that.
Higher education leads to less risk.
That the calculated alpha values doesn't quite tell that story.
That the, or at least the just regular mean variable.
Doesn't tell that story. But that, you know.
Is kind of the value of these methods that it's trying to.
Pick up on this pattern and it's at least hinting at there's.
Some pattern here that even though the data is showing what it is, it might be.
It's skewed in some way that these models were able to pick up on some pattern.
That wants to say that higher education here...
is going to lead to less risk, at least for these transitory shops.
And for tenure...
You see...
A similar story as before as
for the top 10% riskiest, the model predicts 80% riskiest.
10% of them should be in the zero one, 10 year bin, 10.
10% should be in the two to five year bin and 10.
10% in the six or more year bin and for the bottom 10%.
Rescuist it's predicting that 74%
of them should be in the 6 or more years of tenure.
And it predicts 18% and 8% for the 2 to 4.
And the 0 to 1 bins. Saying that for 10 years it's...
Saying it should heavily skew towards longer 10 year should.
The less risky.




