# Online Store of Video Games Analysis

The online store sells video games worldwide. Historical data from open sources is available on game sales, user and expert ratings, genres, and platforms (e.g., Xbox or PlayStation). is essential to identify the presence or absence of regional differences in game consumer preferences.

## Research Objective:

Identify patterns that determine the success of games, which will allow for betting on potentially popular products and planning advertising campaigns for the next year.

## Study stages:

- Assess the suitability of the initial data for further analysis and conduct data preprocessing.
- Identify the relevant period for which the data will be analyzed.
- Assess the popularity of platforms.
- Analyze the impact of game characteristics such as platforms, genre, critic and user ratings on game sales volume.
- Identify the presence or absence of regional differences in game consuming.
- Test hypotheses about the existence of a statistically significant difference in the popularity of games across various platforms and genres.

## Summary of the Analysis Results

Based on the exploratory data analysis:

- The graph of game releases by year shows a sharp increase in game production in 1995 and 2002, peaking in 2008-2009, and declining to a plateau in 2012-2016. From this, we can forecast stable development of the gaming industry for 2017.
- In the last decade, new generations of platforms have entered the market every 5-6 years. The only platform that has shown stable average results over the years is the personal computer (PC).
- The most popular and promising platforms are PS (PS3, PS4), Xbox (X360, XOne), DS (3DS), and Wii (WiiU).
- For detailed analysis, the period from 2012 to 2016 was selected.
- Critics' and users' ratings have little effect on sales.
- The genre of games significantly affects sales. The most popular genres by average sales per game are Shooter, Platform, and Sports. Based on aggregated data considering the total number of games released, the most popular genres are Action, Shooter, and Role-Playing. The least popular genres by any calculation method are Strategy, Puzzle, and Adventure.
- Genre popularity trends are similar in North America and Europe, while in Japan Role-Playing takes the top spot, and Platform makes it into the top 5.
- The North American region leads in sales volume, surpassing other regions combined. In North America and Europe, the most popular platforms are Xbox (X360) and PlayStation (PS3, PS4), while in Japan, the locally produced Nintendo (3DS) platform is most popular.
- In North America, games with an M rating are the most popular, while those with a T rating are the least popular. Games produced in Japan and Europe have significantly lower sales volumes.

When planning campaigns for the following years, it is necessary to focus on the latest models of the most popular platforms - Xbox One, PS4, 3DS, WiiU. In planning marketing campaigns, it is not necessary to emphasize improving critics' and users' ratings, but regional market peculiarities should definitely be considered: different genres and platforms are popular in different markets.
  
## Libraries used:

*pandas*,  *json*,  *matplotlib*, *seaborn*, *scipy*, *pylab*, *re*
