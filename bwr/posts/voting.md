---
title: Why I'm voting in November
layout: wikipage
math: true
---

> Disclaimer: I am not a professional at anything other than writing software. These are my dumb attempts at quantifying a decision making process. In some places, I think these steps are reasonable; in others, I think they're a bit wishy-washy and even probably wrong.

> I've ignored actual election procedures here (primarily the electoral college), because they make it more complicated, and I suspect that the results are more likely to be wrong for unrelated reasons. If you think I'm wrong about this, let me know how to correct the model.

## The probability of changing the outcome of the presidential election

PredictWise has an estimate of prediction markets' subjective probability of this; It's likely to move further from $50\%$ as the election gets closer. I'll assume that I don't have any insider knowledge that isn't reflected in the markets, so I'll adopt the prediction market's estimate as my subjective credence that my candidate will win.

We need to choose a probability distribution over the possible spreads in the election, to determine the probability that the spread is 0 (meaning a tie). If I'm doing probability right, and I'm probably not, this seems to be described well by a binomial distribution with $n = \text{the number of people who will vote}$, and $p$ chosen such that the right proportion of the probability mass is on either side of 0, to satisfy the prediction markets. That is, if PredictWise thinks there's a 10% chance of the election being won by person A, and a 90% chance of it being won by person B, and there are only ten voters, we should choose approximately p = 0.27 that a given voter will choose person A. In this case, the probability of a tie is about 0.075.

There's a problem with this: There are *lots* of voters. Binomial distributions get really hard to calculate exactly at large values of $n$ (even with a powerful computer), so we might benefit by trying an approximation. The standard approximation of a binomial distribution with large $n$ and middling $p$ is the normal distribution, with $\mu = np$ and $\sigma^2 = np(1-p)$.

If I take the current prediction from PredictWise, I see that Hillary Clinton has a $69\%$ chance of winning the election. If you fit a normal distribution, intended to approximate the binomial, to this information (and the assumption that about $140,000,000$ people will vote, based on the last several decades worth of voter turnout rates), you get a mean of about $70,003,000$ and a std deviation of about $5916$, corresponding to a binomial distribution with $n=140,000,000$ and $p=0.5000214$.

> This is an extraordinarily tight distribution, and this makes me think that I'm misapplying statistics here. But it's my best guess at how I should do it.
> 
> In particular, I think I'm confusing my subjective credence about the outcome of the election with an objective, frequentist-style probability distribution. Still, I couldn't think of anything better. I'd be interested to learn what the right way is.

Assuming that's all correct, you can estimate the probability of a tie ($P(\text{tie})$) by the PDF of the distribution at 70,000,000, which is about $5.9\times 10^{-5}$, or $1/17000$.

Not much of a chance is it?

Well, let's see how much I care about the election.

## How much I care about the election results

Imagine that, this very instant, you're unexpectedly transported to a wizard's house. You know that this wizard is very powerful and benevolent to you, and you trust that what he says is true. He tells you "I will make the election come out in your favor if you give me \[some amount of money\]; otherwise I will make your candidate lose. I have been given this power by the government, so it's not illegal and you won't get in any trouble. You have to make your decision right now, and it's not transferable in any way."

I suspect that most people will accept this offer for values below some threshold, and reject it for values above this threshold. That threshold, call it $X$, describes how much you care about the outcome of the election, in terms of dollars.

Unfortunately, humans don't value money on a linear scale, so this value is highly dependent on lots of facts about you *besides* how much you care about the election. It probably depends strongly on your income (and maybe some other factors). But we can correct for that!

It seems like people's happiness (and thus, allegedly, their utility) scales pretty well with the log of their income.

Say I was going to make \$$I$ in income over the next four years. If I subtract \$$X$ from my income, it becomes \$$(I - X)$. Thus the utility I would be willing to spend to choose the outcome of this election is $E = \log(I) - \log(I - X)$. You can figure this number out for yourself.


## The cost of voting

To decide whether voting is worth it or not, we also need to estimate the cost of voting (in marginal utility). I don't know your life, but in my case this cost is very small. If you had a choice between going through the hassle and opportunity cost of voting, vs paying some amount of money, what's the threshold at which you'd choose to go through the hassle? Call that $Y$.

You can do the same calculation as above to figure out how much voting costs you in marginal utility:

$V = log(I) - log(I - Y)$

## Is voting worth it?

So, how much is voting worth to us in expectation? Well, in the case when the election is not tied, it's worth $-V$.
In the case when it *is* tied, it's worth $E - V.$ Thus, the expected value of voting is $P(\text{tie}) * (E - V) + P(\sim \text{tie}) * -V$.

For me, this number comes out to be positive. It would be negative if I thought voting were significantly more costly, or if I would pay that weird wizard guy significantly less. So it's definitely possible that your numbers will come out differently.

If that's the case, though, consider that this calculation was conservative in an important way: Namely, that you actually get to take part in multiple elections on election day for no extra cost. While those elections might not be as important as the presidential one, many of them are still quite important, *and* you have a much higher chance of influencing them, because they elect officials or enact policies that are voted on by a much smaller number of people (I'm referring to congressional elections, as well as state and local elections).
