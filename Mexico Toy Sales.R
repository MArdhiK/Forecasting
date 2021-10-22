---
title: "FORECAST NEXT 3 MONTHS "
---

#Package

library(dplyr)     
library(stringr)   
library(tidyr)     
library(ggplot2)    
library(modeltime)  #modelling time series
library(tidymodels) #modelling time series
library(timetk)     #data wrangling and visualization of time series
library(lubridate)  #for work with dates and datetimes
library(tidyverse)  #data wrangling
library(anomalize)  #anomaly in time series
library(readr)


#Open the file

sales <- read_csv("sales.csv")
products <- read_csv("products.csv")
stores <- read_csv("stores.csv")


#Join all of the file, and drop the unnecessary column

Sales<-sales %>%
  left_join(products, by=c("Product_ID"="Product_ID"))%>%
  left_join(stores, by=c("Store_ID"="Store_ID"))
Sales<-Sales[-c(1,3,4,13)] #Drop Sale_ID, Store ID, Product ID, Store open date
Sales


#Delete the "$" symbol in column product cost and product price and change to numeric type, and make new column to count the total cost and total price

Sales<-Sales%>%
  mutate(Product_Cost=str_replace(Product_Cost,"\\$",""))%>%
  mutate(Product_Price=str_replace(Product_Price,"\\$",""))%>%
  mutate(Product_Cost=as.numeric(Product_Cost))%>%
  mutate(Product_Price=as.numeric(Product_Price))%>%
  mutate(Total_Cost=Units*Product_Cost)%>%
  mutate(Total_Price=Units*Product_Price)
Sales


#Extract day and month from column Date and make new column based on it and reorder to make it nice to look

Sales<-Sales %>%
  mutate(Day = lubridate::day(Date),
         Month = month.name[lubridate::month(Date, label = TRUE)])

Sales<-Sales[, c(1,12,13,2,3,4,5,6,10,11,7,8,9)]
Sales


#Check the NA rows

colSums(is.na(Sales))


#Lets look total Sales each day

Sales_day<-Sales%>%
  group_by(Day)%>%
  summarise(Total.Sales=sum(Total_Price))%>%
  arrange(desc(Total.Sales))

ggplot(data=Sales_day,aes(
  x=reorder(Day,Total.Sales),
  y=Total.Sales))+
geom_col(aes(fill=Total.Sales),show.legend = FALSE)+
theme_bw()+
theme(axis.text=element_text(size=10),
      axis.title=element_text(size=12, colour="black"))+
labs(title = "Total Sales Each Day",
     subtitle = "January 2017 - September 2018",
     x = "Day",
     y = "Total Sales")




Sales%>%
  group_by(Day, Product_Category)%>%
  summarise(Total.Price = sum(Total_Price))%>%
  
  ggplot(aes(
    x=reorder(Day,Total.Price),
    y=Total.Price,
    fill=Product_Category))+
  geom_col(position = "stack")+
  theme_bw()+
  theme(legend.position = "bottom")+
  labs(title = "Sales Composition Each Day Based Product Category",
       subtitle = "Sales From January 2017 - September 2018",
       x = "Day",
       y = "Total Sales")



#Lets look total Sales each month

Sales_month<-Sales%>%
  group_by(Month)%>%
  summarise(Total.Sales=sum(Total_Price))%>%
  arrange(desc(Total.Sales))

ggplot(data=Sales_month,aes(
  x=reorder(Month,Total.Sales),
  y=Total.Sales,
  label=Total.Sales))+
  geom_col(aes(fill=Total.Sales),show.legend = FALSE)+
  coord_flip()+
  theme_bw()+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=12, colour="black"))+
  geom_label(aes(fill=Total.Sales),
             colour="white",
             size=4,
             show.legend = FALSE,
             position = position_stack(0.9))+
  labs(title = "Total Sales Each Month",
       subtitle = "January 2017 - September 2018",
       x = "Month",
       y = "Total Sales")




Sales%>%
  group_by(Month, Product_Category)%>%
  summarise(Total.Price = sum(Total_Price))%>%
  
  ggplot(aes(
    x=reorder(Month,Total.Price),
    y=Total.Price,
    fill=Product_Category))+
  geom_col(position = "stack")+
  coord_flip()+
  theme_bw()+
  theme(legend.position = "bottom")+
  labs(title = "Sales Composition Each Month Based Product Category",
       subtitle = "Sales From January 2017 - September 2018",
       x = "Month",
       y = "Total Sales")



#Lets check the top 10 product

Sales%>%
  group_by(Product_Name)%>%
  summarise(Total.Price=sum(Total_Price))%>%
  arrange(desc(Total.Price))%>%
  head(10)%>%

ggplot(aes(
  x=reorder(Product_Name,Total.Price), 
  y = Total.Price, 
  label = Total.Price))+
geom_col(aes(fill = Total.Price), show.legend = FALSE)+
coord_flip()+
theme_bw()+
theme(axis.text = element_text(size = 10), 
      axis.title = element_text(size = 12, colour = "black"))+
geom_label(aes(fill = Total.Price),
           colour = "white",
           size = 4,
           show.legend = FALSE,
           position = position_stack(0.9))+
labs(title = "Total Sales Based on Product Names",
     subtitle = "Top 10 Product Sales From January 2017 - September 2018",
     x = "Product Names",
     y = "Total Sales")



#Now lets see the Store name that made the highest sales

Sales%>%
  group_by(Store_Name)%>%
  summarise(Total.Price=sum(Total_Price))%>%
  arrange(desc(Total.Price)) %>%
  head(10)%>%


ggplot(aes(
  x=reorder(Store_Name,Total.Price), 
  y = Total.Price, 
  label = Total.Price))+
geom_col(aes(fill = Total.Price), show.legend = FALSE)+
coord_flip()+
theme_bw()+
theme(axis.text = element_text(size = 8), 
      axis.title = element_text(size = 10, colour = "black"))+
geom_label(aes(fill = Total.Price),
           colour = "white",
           size = 4,
           show.legend = FALSE,
           position = position_stack(0.9))+
labs(title = "Total Sales Based on Stores Name",
     subtitle = "Top 10 Stores Sales From January 2017 - September 2018",
     x = "Store Names",
     y = "Total Sales")



#Now lets see the store location

Sales%>%
  group_by(Store_Location)%>%
  summarise(Total.Price=sum(Total_Price))%>%
  arrange(desc(Total.Price))%>%
  
ggplot(aes(
  x=reorder(Store_Location,Total.Price), 
  y = Total.Price, 
  label = Total.Price))+
geom_col(aes(fill = Total.Price), show.legend = FALSE)+
coord_flip()+
theme_bw()+
theme(axis.text = element_text(size = 10), 
      axis.title = element_text(size = 12, colour = "black"))+
geom_label(aes(fill = Total.Price),
           colour = "white",
           size = 4,
           show.legend = FALSE,
           position = position_stack(0.8))+
labs(title = "Store Location Total Sales",
     subtitle = "Sales From January 2017 - September 2018",
     x = "Location",
     y = "Total Sales")




Sales%>%
  select(Store_Location, Product_Category, Total_Price)%>%
  group_by(Store_Location, Product_Category)%>%
  summarise(Total.Price = sum(Total_Price))%>%

ggplot(aes(
  x=reorder(Store_Location,Total.Price),
  y=Total.Price,
  fill=Product_Category))+
geom_col(position = "stack")+
coord_flip()+
theme_bw()+
theme(legend.position = "bottom")+
labs(title = "Sales Composition in Store Location Based Product Category",
     subtitle = "Sales From January 2017 - September 2018",
     x = "Location",
     y = "Total Sales")
  



#sales daily time series 

sales_daily<-Sales%>%
  mutate(Date=floor_date(Date, unit="day"))%>%
  group_by(Date)%>%
  summarise(Total.Price=sum(Total_Price))
sales_daily%>%plot_time_series(Date,Total.Price,
                               .title = "Daily Sales January 2017 - September 2018")


#check the anomaly and clear

sales_daily%>%
  plot_anomaly_diagnostics(Date, Total.Price)




sales_daily2<-sales_daily%>%
  time_decompose(Total.Price)%>%
  anomalize(remainder)%>%
  clean_anomalies()%>%
  select(Date, observed_cleaned)%>%
  rename(Total.Price=observed_cleaned)
sales_daily2%>%plot_time_series(Date, Total.Price)


#Check the stationary

library(tseries)
sales_daily_test=ts(sales_daily2$Total.Price, start = c(2017,1,1),frequency = 365.25)


test for stationary with adf and pp

adf.test(sales_daily_test);
pp.test(sales_daily_test)

since in adf and pp test, p-value less than 0.05, the data is stationary


#seasonal diagnostics

sales_daily2%>%
  plot_seasonal_diagnostics(Date, Total.Price,
                            .feature_set = c("wday.lbl","month.lbl"))



#Now lets split date train and date test, (train80% ; test20%)

splits<-initial_time_split(sales_daily2, prop = 0.8)

#you can also use this  
#splits<-time_series_split(sales_daily,
#                          assess = "4 months",
#                          cumulative = TRUE) #tells the sampling to use all of the prior data as the training set.
  
splits%>%
  tk_time_series_cv_plan()%>%
  plot_time_series_cv_plan(Date,Total.Price)




#Snaive

model_snaive<-naive_reg()%>%
  set_engine("snaive")%>%
  fit(Total.Price~Date, training(splits))
model_snaive


#ETS

model_ets<-exp_smoothing()%>%
  set_engine("ets")%>%
  fit(Total.Price~Date, training(splits))
model_ets


#ARIMA

model_arima<-arima_reg()%>%
  set_engine("auto_arima")%>%
  fit(Total.Price~Date, training(splits))
model_arima



#Prophet
{r,, message=FALSE, warning=FALSE}
model_prophet<-prophet_reg(
  seasonality_yearly  = TRUE)%>%
  set_engine("prophet")%>%
  fit(Total.Price~Date, training(splits))
model_prophet


#modeltimetable

model_tbl<-modeltime_table(
  model_snaive,
  model_ets,
  model_arima,
  model_prophet)
model_tbl


#calibrate

calibrate_tbl<-model_tbl%>%
  modeltime_calibrate(testing(splits))
calibrate_tbl


~Calibration is how confidence intervals and accuracy metrics are determined. <br/>
~Calibration Data is simply forecasting predictions and residuals that are calculated from out-of-sample data. <br/>
~After calibrating, the calibration data follows the data through the forecasting workflow.


#accuracy

calibrate_tbl%>%modeltime_accuracy()


#Test Set Visualization

calibrate_tbl%>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = sales_daily2)%>%
  plot_modeltime_forecast()%>%
  plotly::layout(
    legend=list(
      orientation="h",
      xanchor="center",
      x=0.5,
      y=-0.2))

 

#FORECAST FUTURE

future_forecast_tbl<-calibrate_tbl%>%
  modeltime_refit(sales_daily2)%>% #retrain on full data
  modeltime_forecast(
    h = "3 months",
    actual_data = sales_daily2)

future_forecast_tbl%>%
  plot_modeltime_forecast()%>%
  plotly::layout(
    legend=list(
      orientation="h",
      xanchor="center",
      x=0.5,
      y=-0.2))



#Forecast with prophet

model_prophet2<-prophet_reg(
  growth = "linear", #see the trend
  prior_scale_changepoints = 0.4, #Parameter modulating the flexibility of the automatic changepoint selection
  prior_scale_seasonality = 5, #modulating the strength of the seasonality model
  seasonality_yearly  = TRUE,
  seasonality_weekly = TRUE,
  seasonality_daily = FALSE)%>%
  set_engine("prophet")%>%
  fit(Total.Price~Date, training(splits))




model_tbl2<-modeltime_table(
  model_prophet,
  model_prophet2)

calibrate_tbl2<-model_tbl2%>%
  modeltime_calibrate(testing(splits))

calibrate_tbl2%>%modeltime_accuracy()




calibrate_tbl2%>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = sales_daily2)%>%
  plot_modeltime_forecast()%>%
  plotly::layout(
    legend=list(
      orientation="h",
      xanchor="center",
      x=0.5,
      y=-0.2))





future_forecast_tbl2<-calibrate_tbl2%>%
  modeltime_refit(sales_daily2)%>% #retrain on full data
  modeltime_forecast(
    h = "3 months",
    actual_data = sales_daily2)

future_forecast_tbl2%>%
  plot_modeltime_forecast(.title = "Forecast 3 Months")%>%
  plotly::layout(
    legend=list(
      orientation="h",
      xanchor="center",
      x=0.5,
      y=-0.2))
