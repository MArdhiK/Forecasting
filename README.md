# Forecasting

This is daily sales data of toy sales from Mexico store that I get from kaggle : https://www.kaggle.com/mysarahmadbhat/toy-sales  

After some processing, the data consist of consists of 829,262 rows and 13 columns

You can kindly check my interactive picture in rpubs : https://rpubs.com/mardhik/851471

Forecasting with SNAIVE, SARIMA, ETS, PROPHET

After some tuning on prophet, MAPE of PROPHET is 14,0%

------------------------------------------------------------

### Here's some of the EDA that I've done, there is more of it in the documents   
#### 1. Comparison between Total Sales and Total Unit Sold   
<img src=images/1.salescomposition.png width=400>        <img src=images/2.totalunitsold.png width=400>

- Take a look at every 1st and 15th is the highest
- Highest sales category is "Toys" and the lowest is "Sports & Outdoors"
- Highest unit sold category is "Art & Crafts" and the lowest is "Electronics"


#### 2. Store Location Sales Composition
<img src=images/3.storesales.png width=400>        <img src=images/4.storesalescomposition.png width=400>

- Downtown location is dominating in total sales
- 'Toys' is dominating in every location   
- After 'toys', the second total sales product category is different in each location


#### 3. Total Unit Sold in Each Location Everyday
<img src=images/5.saleslocationday.png width=500>

- Saturday and Sunday are the highest in every store location                   
- Every store location has same pattern, after sunday decrease and then increase
   
    
### Model Comparison
#### Visual Comparison SNAIVE and ETS
<img src=images/6.snaive.png width=400>       <img src=images/7.ets.png width=400>


#### Visual Comparison ARIMA and PROPHET
<img src=images/8.arima.png width=400>       <img src=images/9.prophet.png width=400>


#### Comparison All of Them
<img src=images/12.comparison.png length=400>


#### Comparison Prophet1 and Prophet2
<img src=images/13.comparison2.png length=400>


#### The Forecast used Prophet2
<img src=images/11.next3monthsprophet.png width=500>

