# Study on Increasing Revenue for an Online Store

Employees of the online store have prepared a list of hypotheses to increase revenue. The purpose of this study is to prioritize the hypotheses and analyze the results of an A/B test to evaluate the effectiveness of changes on the web platform/business processes.

The analysis will focus on key metrics such as average order value, number of orders, and revenue to determine the impact of the implemented changes on user behavior. A comparative analysis of two groups - the control group (Group A) and the test group (Group B) - will be conducted. The study will examine how the planned changes may affect the key metrics, leading to a conclusion about the feasibility of further A/B testing and the permanent implementation of the planned changes.

## Research Objective:

Analyze the results of an A/B test to evaluate the effectiveness of changes on the web platform/business processes.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Apply ICE and RICE frameworks to prioritize hypotheses and compare the results.
- Determine cumulative revenue, number of orders, and average order value for the A/B test groups based on available dat.;- Identify anomalies in the data and establish anomaly boundari.s- ; Calculate the statistical significance of differences in average number of orders per visitor and average order value using the initial and anomaly-free d.t- a; Decide on the success of the A/B test and whether to conclude or continue it.

## Summary of the Analysis Results

After removing outliers in the original data frames and based on the results of the Mann-Whitney test, the following conclusion can be drawn:

- There is a statistically significant difference in the average number of orders between groups A and B, but no difference in the average order value.
- Users in group B placed almost 20% more orders compared to users in group A; however, by the end of the test, their average order value fell below that of group A.

If testing continues:

- If the average order value remains the same or increases, group B will emerge as the winner.
- If the average order value in group B decreases relative to group A, the results may equalize or group A may take the lead.

## Libraries used:

*pandas*,  *json*,  *matplotlib*, *scipy*, *numpy*
