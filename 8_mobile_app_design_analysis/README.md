# Study on the Redesign of a Mobile Application

The designers of a mobile application for food sales have planned to change the fonts throughout the entire app. The company management decided to first conduct an A/A/B experiment. Users were divided into 3 groups: 2 control groups (246 and 247), whose apps displayed the old fonts, and one experimental group (248) with the new fonts.

## Research Objective:

Studying the sales funnel to identify stages with the lowest user conversion rates, and analyzing the results of the A/A/B experiment to determine the feasibility of changing fonts.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Define the time period for data analysis.
- Identify optional app interaction stages, clean the data, construct and analyze the product funnel.
- Pairwise compare of A/A, B group results and each of A, B and cumulative A, A group results based on user counts and proportions at each stage, and evaluate the statistical significance of the observed differences.

## Summary of the Analysis Results

The analyzed dataframe contains data for a two-week period from 25th July 2019 to 7th August 2019, but for research purposes, only data from the second week was selected due to insufficient completeness in the other data. This resulted in a reduction of the dataframe by less than 1%.

The dataframe includes information on 5 unique events, with 4 forming the product funnel: MainScreenAppear, OffersScreenAppear, CartScreenAppear, and PaymentScreenSuccessful. The lowest conversion rate is observed when users transition from the main screen to the offers screen, slightly over 60%. Possible reasons for this low conversion could be technical issues during the transition or an interface that is not user-friendly, posing navigation problems beyond the main screen. Overall, from entering the main screen to successfully paying for products/services, slightly less than half of all users proceed — about 48%.

Pairwise comparison of A/A, B groups and each of A, B and cumulative A, A group results based on user counts and proportions at each stage of the product funnel showed no statistically significant differences between groups 246 and 247, indicating their suitability as control ones. Meanwhile, no statistically significant differences were also found between the experimental group and the control groups at any of the stages. Therefore, the A/A/B testing can be concluded with the finding of no differences between the groups.

Based on the study results, the implementation of new fonts in the application is not recommended.

## Libraries used:

*pandas*,  *json*,  *matplotlib*, *scipy*, *numpy*, *plotly.express*, *math*
