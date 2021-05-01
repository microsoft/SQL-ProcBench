--Compute store sales net profit ranking by state and city for a given year 
--and determine the five most profitable states. 

Create or replace Function maxProfitStates(givenYear int)
RETURNS TABLE(state char(2), city varchar(60), profit decimal(15, 2))
language plpgsql
as $$
begin
	return query
		select s_state, s_city, sum(ss_net_profit) as totalProfit 
		from store_sales_history, store, date_dim
		where ss_store_sk = s_store_sk
			and ss_sold_date_sk = d_date_sk
			and d_year = @givenYear
		group by s_state, s_city
		order by totalProfit desc
		limit 5;
end; $$

