--8) What is the ratio between the number of items sold over the internet in the morning (8 to 9am) to the number of
--items sold in the evening (7 to 8pm) of customers with a specified number of dependents. 

create or replace function morningToEveRatio(dep int)
return float
is
    morningSale number; eveningSale number; ratio number;
begin
	select count(*) into morningSale 
    from web_sales_history, time_dim, customer_demographics
    where ws_sold_time_sk = t_time_sk and ws_bill_customer_sk = cd_demo_sk
    and t_hour>=8 and t_hour<=9
    and cd_dep_count=dep;

	select count(*) into eveningSale
	from web_sales_history, time_dim, customer_demographics 
	where ws_sold_time_sk = t_time_sk and ws_bill_customer_sk = cd_demo_sk
		and t_hour>=19 and t_hour<=20
		and cd_dep_count=dep;

	ratio := morningSale/eveningSale;
	return ratio;
end;



select depCount, morningToEveRatio(depCount) from
(select distinct cd_dep_count as depCount from customer_demographics)t;
