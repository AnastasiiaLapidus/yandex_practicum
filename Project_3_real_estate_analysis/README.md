# Study of Real Estate Listings
The data is provided by the Yandex.Real Estate service and represents an archive of apartment sale listings in St. Petersburg and neighboring localities from 2014-2019. The aim of the study is to establish parameters for automating the evaluation of the market value of real estate properties.

For each real estate object in the dataset, two types of data are available: the first type is entered by the user, and the second type is obtained automatically based on mapping data (e.g., distance to the center, airport, nearest park, and body of water).

## Research Objective

Establishing parameters for automating the determination of real estate objects market value.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Identify the most frequent as well as rare values of various real estate parameters.
- Analyze the impact of different parameters on the overall value of the properties.
- Calculate the price per square meter of real estate.
- Formulate criteria for the automatic determination of real estate value.

## Summary of the Analysis Results

Properties with the highest frequency are characterized by:

- a total area of 25-60 square meters;
- a living area of 15-22 square meters or 27-32 square meters (predominantly apartments);
- a kitchen area of 5-15 square meters;
- a price of 3-6 million rubles;
- 1-3 rooms;
- not being located on the first or last floor;
- being in buildings with 5 and 9 floors;
- being 10-18 km from the city center;
- having the nearest park within 500 meters from the house.
  
For small and medium properties with total area up to 130 square meters, living area up to 75 square meters, kitchen area up to 15 square meters, and up to 4 rooms, the area and number of rooms have a direct influence on the total cost. As the area of the property increases, the correlation decreases, and other parameters of the property start to have a stronger impact on the cost.

Being located on the first and last floor has a negative impact on the overall cost.

The real estate market in the Leningrad region is characterized by seasonality, with peaks in listed property cost (as a result of increased demand) in April, September, and November. The market also directly dependents on the general economic situation in the country.

Localities with the highest price per square meter are Zelenogorsk and St. Petersburg, while the cheapest real estate is in the village of Staropolye.

As the distance from the center increases, the cost of real estate steadily decreases from 0 to 25 km. Beyond that, it sharply increases when apartments are located in elite peripheral areas at a distance of 25 to 30 km from the center.
  
## Libraries used:

*pandas*,  *json*,  *matplotlib*, *seaborn* 
