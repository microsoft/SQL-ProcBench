--Output the late delivery statistics of each of the 2 delivery channels

Create or Alter Function ChannelWiseLateDeliveryStatistics(@channel char(1), @year integer)
RETURNS @deliveryStats TABLE(warehouseName varchar(20), shipMode char(30), thirty_days int, sixty_days int,
							ninety_days int, oneTwenty_days int, veryLate int)
begin
	if(@channel='c')
	begin
		INSERT into @deliveryStats
				SELECT w_warehouse_name, sm_type,
					Sum(CASE 
							WHEN ( cs_ship_date_sk - cs_sold_date_sk <= 30 ) THEN 1 
							ELSE 0 
						END) AS thirty_days, 
					Sum(CASE 
							WHEN ( cs_ship_date_sk - cs_sold_date_sk > 30 ) 
								AND ( cs_ship_date_sk - cs_sold_date_sk <= 60 ) THEN 1 
							ELSE 0 
						END) AS sixty_days,
					Sum(CASE 
							WHEN ( cs_ship_date_sk - cs_sold_date_sk > 60 ) 
								AND ( cs_ship_date_sk - cs_sold_date_sk <= 90 ) THEN 1 
							ELSE 0 
						END) AS ninety_days, 
					Sum(CASE 
							WHEN ( cs_ship_date_sk - cs_sold_date_sk > 90 ) 
								AND ( cs_ship_date_sk - cs_sold_date_sk <= 120 ) THEN 
							1 
							ELSE 0 
						END) AS oneTwenty_days, 
					Sum(CASE 
							WHEN ( cs_ship_date_sk - cs_sold_date_sk > 120 ) THEN 1 
							ELSE 0 
						END) AS veryLateDelivery
		
				FROM   catalog_sales_history, warehouse, ship_mode, date_dim 
				WHERE  d_year BETWEEN @year AND @year+5
					   AND cs_ship_date_sk = d_date_sk 
					   AND cs_warehouse_sk = w_warehouse_sk 
					   AND cs_ship_mode_sk = sm_ship_mode_sk 
				GROUP  BY w_warehouse_name, 
						  sm_type 
	end

	else if(@channel='w')
	begin
		INSERT into @deliveryStats
				SELECT w_warehouse_name, sm_type, 
					Sum(CASE 
							WHEN ( ws_ship_date_sk - ws_sold_date_sk <= 30 ) THEN 1 
							ELSE 0 
						END) AS thirty_days, 
					Sum(CASE 
							WHEN ( ws_ship_date_sk - ws_sold_date_sk > 30 ) 
								AND ( ws_ship_date_sk - ws_sold_date_sk <= 60 ) THEN 1 
							ELSE 0 
						END) AS sixty_days,
					Sum(CASE 
							WHEN ( ws_ship_date_sk - ws_sold_date_sk > 60 ) 
								AND ( ws_ship_date_sk - ws_sold_date_sk <= 90 ) THEN 1 
							ELSE 0 
						END) AS ninety_days, 
					Sum(CASE 
							WHEN ( ws_ship_date_sk - ws_sold_date_sk > 90 ) 
								AND ( ws_ship_date_sk - ws_sold_date_sk <= 120 ) THEN 
							1 
							ELSE 0 
						END) AS oneTwenty_days, 
					Sum(CASE 
							WHEN ( ws_ship_date_sk - ws_sold_date_sk > 120 ) THEN 1 
							ELSE 0 
						END) AS veryLateDelivery
				FROM   web_sales_history, 
					   warehouse, 
					   ship_mode, 
					   date_dim 
				WHERE  d_year BETWEEN @year AND @year+5
					   AND ws_ship_date_sk = d_date_sk 
					   AND ws_warehouse_sk = w_warehouse_sk 
					   AND ws_ship_mode_sk = sm_ship_mode_sk 
				GROUP  BY w_warehouse_name, 
						  sm_type
	end

	return;
end
go

--calling : select dbo.ChannelWiseLateDeliveryStatistics('c', 1998);
select warehouseName , shipMode , thirty_days , sixty_days ,
							ninety_days , oneTwenty_days , veryLate 
from dbo.ChannelWiseLateDeliveryStatistics('c', 1998)
