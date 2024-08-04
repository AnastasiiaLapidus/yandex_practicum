# Analysis of Bank Customer Churn

Recently, the bank has experienced an increase in customer churn. Previously, churn analysis was conducted, dashboards were created, and segments were identified, but the customer base has since changed, rendering current solutions ineffective. The client for this analysis is the bank's marketing department, which needs to identify customer segments with the highest churn rates. The marketing department plans to send out targeted communications to customers in these identified segments. Since the mailing process is not automated and is done manually, the identified segments should ensure a highly targeted approach and not be too large.

## Research Objective:

Identify the reasons for customer churn in the bank and formulate recommendations for the marketing department to retain these customers.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Analyze the presence of value/characteristic intervals that distinguish churned clients.
- Perform a correlation analysis of the data.
- Create profiles of customers who are likely and unlikely to leave the bank.
- Formulate and test hypotheses about statistically significant differences between the characteristics of churned and retained customers.
- Identify customer segments with churn rates higher than the bank's average based on the exploratory data analysis.
- Formulate recommendations for the marketing department to retain customers from the identified segments.

## Summary of the Analysis Results

Based on the analysis of the distribution of continuous and categorical features, the following churn intervals and criteria were identified (ranked in order of significance according to the phik correlation analysis method):

- Number of properties owned: 3 or more
- Customer activity: active during the evaluated time period
- Number of bank products used by the customer: 3 or more
- Credit score points: from 820 to 920 (peaking around 850-900 points)
- Gender: male
- Bank credit card: absent
- Age: from 25 to 35 years, from 50 to 60 years
- Estimated salary: from 85 to 230 thousand
- City of residence: Yaroslavl
- Account balance: over 750 thousand
- The hypothesis testing showed that even relatively small differences, such as 1.5 years in age or about 7000 in salary, are statistically significant and can be considered when segmenting customers.

Three user groups were identified based on the segmentation results, and it is proposed that the marketing department should work with these groups to reduce the customer churn rate:

Segment 1 – Balance over 750k, no credit card, active – Recommendation: Offer a specialized travel credit card.

Segment 2 – Male clients, aged 50-60 years, using more than one bank product – Recommendation: Offer special conditions (cashback, discounts) on construction and gardening materials/tools and leisure products.

Segment 3 – Credit score of 850-900 points, residing in Yaroslavl, owning more than 3 properties – Recommendation: Offer a discount on insurance products when insuring more than one property object.

## Libraries used:

*pandas*, *seaborn*, *matplotlib*, *phik*, *numpy*, *scipy*, *json*
