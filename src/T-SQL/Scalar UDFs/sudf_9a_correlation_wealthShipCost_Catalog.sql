-- see if there is correlation betwen paying high shipping costs through catalog and 
--having a large number of high income inhabitants (at the state level))

create or alter function wealth_shipCostCorrelation_cat()
returns varchar(40)
as
begin
	declare @numStates int =0;

	set @numStates = (select count(*) from
	(	select ca_state from 
		(select top 5 ca_state, sum(cs_ext_ship_cost) as sm
		from catalog_sales_history, customer_address
		where cs_bill_customer_sk = ca_address_sk and ca_state is not NULL
		group by ca_state
		order  by sm desc)t1
 
		INTERSECT  

		select ca_state from  --states wth largest numeber high income people
		(select top 5 ca_state, count(*) as cnt
		from customer, household_demographics, customer_address
		where c_current_hdemo_sk = hd_demo_sk and c_current_addr_sk = ca_address_sk and hd_income_band_sk>=15 and ca_state is not NULL
		group by ca_state
		order by cnt desc)t2
	)t3 )

	if(@numStates>=4)
		return 'hihgly correlated';
	if(@numStates>=2 and @numStates<=3)
		return 'somewhat correlated';
	if(@numStates>=0 and @numStates<=1)
		return 'no correlation';
	return 'error';
end