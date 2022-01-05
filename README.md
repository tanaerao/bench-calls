# Frequency of bench calls in British Parliamentary debating

**Summary:** Using data from WUDC 2020 and WUDC 2021, I show that bench calls are disproportionately common. Despite representing only 1/3 of possible calls, they are given 40.7% of the time (95% confidence interval: \[0.38,0.43]). One popular explanation for this is that motions are sometimes biased in favour of one bench, hence resulting in a large number of bench calls. I demonstrate, using a model, that even the most extreme observations of motion bias would not result in as high a frequency of bench calls as is present in the data. This puts pressure on the folk wisdom that the ranking between any two teams is unaffected by the performance of other teams in the round.

***

Bench calls are ordinal rankings of the four teams in a British Parliamentary (BP) debating such that two teams on the same 'bench' (government or opposition) place 1st and 2nd. In the examples below, Call A is a bench call, but Call B is not.

**Call A**
1. Opening Government
2. Closing Government
3. Opening Opposition
4. Closing Opposition

**Call B**
1. Opening Government
2. Opening Opposition
3. Closing Government
4. Closing Opposition

One piece of folk wisdom about BP debating is that the ranking between any pair of teams is unaffected by the arguments and rebuttal delivered by other teams in the debate. For example, if Opening Opposition beats Closing Government (as is the case in Call B), then this would hold true regardless of the arguments which might have counterfactually been delivered by Opening Government and Closing Opposition.

If this is true, it may suggest that approximately 1/3 of debates should result in bench calls (as they constitute 8 of the 24 possible orderings of the four teams).[^1] However, evidence from the World University Debating Championships in 2020 and 2021 suggests that bench calls are disproportionately common. This analysis of the results of 1617 debates across 18 distinct rounds finds sufficient evidence to reject the null hypothesis that the true probability of a bench call is 1/3 or lower, with p in the order of magnitude of 10^-10. With 95% confidence, 38.3-41.2% of debates result in bench calls.

<dl>
  <table style="text-align:center"><caption><strong>Inrounds bench call frequency; WUDC 2020 & WUDC 2021</strong></caption>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Round</td><td>Proportion of bench calls</td><td>Number of rooms</td><td>Total number of benchcalls</td><td>Mean points gained by gov teams</td><td>RS model prediction of the proportion of bench calls</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">R1_WUDC_2021</td><td>0.473</td><td>93</td><td>44</td><td>1.527</td><td>0.334</td></tr>
<tr><td style="text-align:left">R2_WUDC_2021</td><td>0.409</td><td>93</td><td>38</td><td>1.387</td><td>0.340</td></tr>
<tr><td style="text-align:left">R3_WUDC_2021</td><td>0.419</td><td>93</td><td>39</td><td>1.511</td><td>0.333</td></tr>
<tr><td style="text-align:left">R4_WUDC_2021</td><td>0.462</td><td>93</td><td>43</td><td>1.328</td><td>0.350</td></tr>
<tr><td style="text-align:left">R5_WUDC_2021</td><td>0.424</td><td>92</td><td>39</td><td>1.429</td><td>0.336</td></tr>
<tr><td style="text-align:left">R6_WUDC_2021</td><td>0.380</td><td>92</td><td>35</td><td>1.473</td><td>0.334</td></tr>
<tr><td style="text-align:left">R7_WUDC_2021</td><td>0.304</td><td>92</td><td>28</td><td>1.516</td><td>0.333</td></tr>
<tr><td style="text-align:left">R8_WUDC_2021</td><td>0.500</td><td>92</td><td>46</td><td>1.239</td><td>0.373</td></tr>
<tr><td style="text-align:left">R9_WUDC_2021</td><td>0.380</td><td>92</td><td>35</td><td>1.375</td><td>0.342</td></tr>
<tr><td style="text-align:left">R1_WUDC_2020</td><td>0.375</td><td>88</td><td>33</td><td>1.614</td><td>0.341</td></tr>
<tr><td style="text-align:left">R2_WUDC_2020</td><td>0.386</td><td>88</td><td>34</td><td>1.432</td><td>0.336</td></tr>
<tr><td style="text-align:left">R3_WUDC_2020</td><td>0.322</td><td>87</td><td>28</td><td>1.632</td><td>0.344</td></tr>
<tr><td style="text-align:left">R4_WUDC_2020</td><td>0.414</td><td>87</td><td>36</td><td>1.506</td><td>0.333</td></tr>
<tr><td style="text-align:left">R5_WUDC_2020</td><td>0.402</td><td>87</td><td>35</td><td>1.282</td><td>0.361</td></tr>
<tr><td style="text-align:left">R6_WUDC_2020</td><td>0.414</td><td>87</td><td>36</td><td>1.195</td><td>0.387</td></tr>
<tr><td style="text-align:left">R7_WUDC_2020</td><td>0.425</td><td>87</td><td>37</td><td>1.218</td><td>0.379</td></tr>
<tr><td style="text-align:left">R8_WUDC_2020</td><td>0.448</td><td>87</td><td>39</td><td>1.224</td><td>0.377</td></tr>
<tr><td style="text-align:left">R9_WUDC_2020</td><td>0.391</td><td>87</td><td>34</td><td>1.402</td><td>0.339</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr></table>
  </dl>

One explanation for this result--an explanation which would allow us to continue believing the folk wisdom--is that some debate motions (the topic of the debate, which is different for every round) are easier for teams on one bench than the other. I will refer to this using the term 'motion bias'.[^2] Consider a motion where it is much easier to come up with compelling arguments for the government bench than for the opposition. We might expect the results of that round to include a larger-than-usual number of bench calls, where the government teams take the 1st and 2nd.

By constructing what I'll call the relative strength model (RS), I show that motion bias accounts for little--if anything at all--of the high frequency of bench calls. The **relative strength** of the government bench over the opposition bench is the probability that a government team would beat an opposition team in a one-on-one debate. To be clear, this relative strength metric is entirely fictious; it is a construct not meant to resemble any actual feature of BP debating.

The question I am trying to answer with this model is 'what is the probability of a bench call, given no information other than the expected points won by government teams, and assuming that the ranking between any pair of teams is independent of the performance of a third?'.[^3]

To simulate a round of debate, the model assigns a performance score to the team in each position, where *RS* is an exogenous and between 0 and 1 (because it is a probability).

*Performance<sub>OG</sub> ~ N(q,1<sup>2</sup>) where q | Pr(N(q,1<sup>2</sup>) > 0) = RS*

*Performance<sub>OO</sub> ~ N(0,1<sup>2</sup>)*

*Performance<sub>CG</sub> ~ N(q,1<sup>2</sup>) where q | Pr(N(q,1<sup>2</sup>) > 0) = RS*

*Performance<sub>CO</sub> ~ N(0,1<sup>2</sup>)*

The performance scores of each team are then ranked from greatest to least. As per the usual scoring system in BP debating, the first ranked team receives 3 points, the second ranked team receives 2 points, the third ranked team receives 1 point, and the last ranked team receives 0 points. The folk wisdom is met in this model, because whether or not A > B is clearly independent of C, where A, B, and C are normally distributed random variables with constant mean and variance.

Having simulated, for a given RS, a large number of calls, I then record the mean points won by government teams, and the proportion of bench calls. For example, Call C is not a bench call, and the government teams win an average of 1.5 points. 

**Call C**
1. Opening Opposition
2. Closing Government
3. Opening Government
4. Closing Opposition

Running Monte Carlo simulations over a large number of values for relative strength (from 0 to 1, going up in intervals of 0.001) reveals the relationship between the average number of points scored by government teams and the proportion of bench calls, provided that the folk wisdom is true (blue line in figure below).

![RS diagram](https://github.com/tanaerao/bench-calls/blob/main/bench-calls-figure-1.png)

In theory, we should expect the proportion of expected bench calls to be 100% when RS = 0, because the two opposition teams will always beat the two government teams. We should also expect 100% bench calls when RS = 1, by the same logic. Finally, the curve should have a global minimum at 1/3 bench calls and 1.5 average government points (which represents a completely unbiased motion; RS = 0.5). This is roughly what we see in the blue line, noting that there is some imprecision because the blue line is a fit to the results of a random simulation.

Motions at WUDC are generally well-balanced. The most unbalanced motion out of the sample was R6 of WUDC 2020, where government teams received 1.195 points on average. This corresponds to an expected 38.7% bench calls under the RS model. We can reject the null hypothesis that the true probability of a bench calls is equal to or below 38.7% at the 5% significance level. In short, even if all motions were as biased as R6 of WUDC 2020, we would still not expect to observe as many bench calls as are present in this sample (if the folk wisdom is true). 

Intuitively, if the probability of a bench call were 1/3, we would expect to see a roughly equal number of red Xs below and above the dotted green line. If the probability of a bench call were higher than 1/3 *solely because of motion bias*, we would expect to see a roughly equal number of red Xs below and above the solid blue curve.

The evidence implies that bench calls are more probable than 1/3, and that motion bias is a poor explanation of this.

## Some comments on the code

If people want to evaluate the proportion of bench calls in other tournaments, they can add additional sheets to the excel file included in this GitHub repo, then run the code. Each sheet should contain the copy-pasted tournament data, arranged by team, of one round of debate. The sheet must be given a unique name. Some tournament sites allow you to copy-paste the table by clicking a button; I don't know how to get the data in a convenient format for tournaments that don't allow this. The data does not have to be ordered by room, or by team position. I've also included the results of the RS model simulation in the repo, so that the (time-intensive) simulation doesn't have to be repeated for every new session.

[^1]: This obviously holds true for rounds in which the expected points won in any position is 1.5. It also holds true for rounds in which any one team receives a higher expected number of points. If two teams across a diagonal (e.g., Opening Government and Closing Opposition) receive a higher expected number of points, then we would expect fewer than 1/3 bench calls. The same is true of the two teams in opening or closing. However, when two teams on the same bench receive a higher expected number of points, we would expect more than 1/3 bench calls; this is the possibility examined in the RS model.
[^2]: Note that I am using the term 'motion bias' in reference solely to motions that are easier on government or on opposition, rather than in reference to--for instance--motions that are easier on opening than on closing.
[^3]: Two things to note here. First, I am assuming that the observed mean points won by government teams in the round is equal to the expected number of points won. This is a charitable assumption that implies more motion bias than there actually is; if all motions were completely unbiased, teams would nonetheless win somewhat more or less than 1.5 points per round, because of randomness. Second, RS is *one* way of generating a plausibly random distribution of calls where government teams average a certain number of points per round. There are perhaps other methods of doing this, which would generate different results (see: Bertrand's Paradox). 
