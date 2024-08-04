# Analysis of the Causes of Losses for the Entertainment Application

Despite significant investments in advertising, the entertainment app's development company has been incurring losses over the past few months.

## Research Objective:

Identify the causes of the losses by the entertainment app's development company.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Define functions for calculating and analyzing LTV, ROI, retention, and conversion rates.
- Create user profiles and determine the user acquisition period.
- Analyze the distribution of users by country, device, and acquisition channels.
- Calculate marketing expenses, including the CAC metric.
- Analyze the profitability of the advertising campaigns based on the LTV, ROI, and CAC graphs.

## Summary of the Analysis Results

The analyzed user acquisition period is from May 1, 2019, to October 27, 2019.

The dataframe contains data about users:

- From four countries: the USA (the majority of users), the UK, France, and Germany;
- Using the following devices: iPhone (majority), Android, Mac, and PC.
  
Distribution of users by acquisition channels: the highest number of users came to the app organically, but the highest number of paying users were acquired through FaceBoom.

Marketing data analysis: high costs for the TipTop acquisition channel (more than 50% of all expenses) brought only 13% of users (including organically acquired users) or 21% (excluding them); the weekly and monthly spending dynamics and the CAC metric indicate that marketing expenses for the TipTop channel are extremely high and tend to increase rapidly, while no data supports the effectiveness of spending such large amounts on this acquisition channel.

Overall, the advertising campaign is not profitable due to high user acquisition costs for specific devices (iPhone and Mac), countries (USA), and acquisition channels (TipTop).

In the future, it is recommended to consider reducing advertising campaigns on expensive channels (TipTop) and expanding them on channels with lower acquisition costs but having ROI value highter then 1, such as lambdaMediaAds and YRabbit. Additionally, it is worth investigating whether there are technical reasons why users from the USA, as well as Mac and iPhone users, convert well to app users but quickly churn.

## Libraries used:

*pandas*,  *json*,  *matplotlib*, *seaborn*, *numpy*
