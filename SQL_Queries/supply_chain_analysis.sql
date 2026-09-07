select * from buisness_operations.supply_chain;


-- 1. Shipping Performance
	-- Top 20 slow Warehouse
select Warehouse_ID, Location, Product_Category,(Order_Processing_Time + Shipping_Time_Days) as Total_Delivery_Time
from supply_chain
order by Total_Delivery_Time desc
limit 20;

	-- Warehouse taking more time in shipping than average shipping time
select Warehouse_ID, Location, (Shipping_Time_Days + Order_Processing_Time) as Delivery_Time
from supply_chain s
where (Shipping_Time_Days + Order_Processing_Time) > (
select avg(Shipping_Time_Days + Order_Processing_Time)
from supply_chain
where Location = s.Location
)
order by Shipping_Time_Days desc;


-- 2. Inventory Levels
	-- Inventory Level & Risk Assessment
select 
	Warehouse_ID, Location, Product_Category, Current_Stock, Warehouse_Capacity, Stockout_Risk
from supply_chain
where Current_Stock < Demand_Forecast
   or Stockout_Risk > 0.25;
   

-- 3. Demand Fluctations
	-- Comparision of forecasted demand against actual sales to measure forecasting accuracy.
select
    Warehouse_ID, Location, Product_Category, Demand_Forecast, Monthly_Sales,
    (Demand_Forecast - Monthly_Sales) as Forecast_Gap
from supply_chain;

	-- Damaged goods and efficiency of workforce
select
    Warehouse_ID, 
    round((Damaged_Goods / Current_Stock) * 100, 2) as Damage_Rate,
    round((Monthly_Sales / Employee_Count)) as Sales_Per_Employee,
    round(Return_Rate,2) as Return_Rate
from supply_chain
order by Damage_Rate desc;