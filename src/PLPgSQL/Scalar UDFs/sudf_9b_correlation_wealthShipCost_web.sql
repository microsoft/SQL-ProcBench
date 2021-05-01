-- see if there is correlation betwen paying high shpping costs through web and 
--having a large number of high income inhabitants (at the state level))

create or replace function wealth_shipCostCorrelation_web()
returns varchar(40)
language plpgsql
as
$$
declare	
	numStates int;
begin
	numStates := 0;

	numStates := (select count(*) from
	(	select ca_state from 
		(select ca_state, sum(ws_ext_ship_cost) as sm
		from web_sales_history, customer_address
		where ws_bill_customer_sk = ca_address_sk and ca_state is not NULL
		group by ca_state
		order  by sm desc
		limit 5)t1
 
		INTERSECT  

		select ca_state from  --states with largest number of high income people
		(select ca_state, count(*) as cnt
		from customer, household_demographics, customer_address
		where c_current_hdemo_sk = hd_demo_sk and c_current_addr_sk = ca_address_sk and hd_income_band_sk>=15 and ca_state is not NULL
		group by ca_state
		order by cnt desc
		limit 5)t2
	)t3 );

	if(numStates>=4) then
		return 'highly correlated';
	end if;
	if(numStates>=2 and numStates<=3) then
		return 'somewhat correlated';
	end if;
	if(numStates>=0 and numStates<=1) then
		return 'no correlation';
	end if;
	return 'error';
end; $$



