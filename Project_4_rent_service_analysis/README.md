# Scooter Rental Service Analysis

Scooter rental service GoFast provided data on user trips from several cities. To travel around the city, GoFast users use a mobile application. The service can be used with or without a subscription. It is necessary to analyze the data and test hypotheses that can help the business grow:

- subscribers spend more time on trips than non-subscribers;
- the average distance that subscribers travel per trip does not exceed 3130 meters;
- monthly revenue from subscribers is higher than revenue from non-subscribers.

## Research Objective:

Conducting a comparison of the behavior of users of the scooter rental service with and without a subscription to assist in determining further development strategies for the service.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Identify the most frequent values of user characteristics such as city of residence, subscription status, age, distance, and duration of trips.
- Compare the characteristics of users with and without a subscription.
- Test hypotheses about the similarity of behavior between users with and without a subscription.

## Summary of the Analysis Results

Based on the data analysis results:

- The data is equally representative for all 8 cities where the service operates.
- The highest number of service users is in Pyatigorsk, and the lowest - in Moscow.
- The number of non-subscribers exceeds the number of subscribers by 19% (835 vs. 699).
- The most common age range of users is 22-28 years.
- Two scooter usage strategies were identified: for short distances (peak value - 750 meters) and for long distances (peak value - 3000 meters) (this data can be used to adjust pricing plans).
- The most frequent trip duration is 12-22 minutes.
- A peak of 0.5-minute trips with a significant distance covered was identified, characteristic only for non-subscribers. This may indicate a technical malfunction in the application.
  
Based on the hypothesis testing results:

- With the highest probability, subscribers will spend more time on trips than non-subscribers and will also generate more revenue.
- There is a 33% probability that the average distance traveled by a subscriber will be 3130 meters.
  
## Libraries used:

*pandas*,  *json*,  *matplotlib*, *seaborn*, *numpy*, *scipy*, *pylab*
