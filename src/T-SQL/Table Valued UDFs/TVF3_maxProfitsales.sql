--Compute store sales net profit ranking by state and city for a given year 
--and determine the five most profitable states. 

Create or Alter Function dbo.maxProfitStates(@givenYear int)
RETURNS @profitRanking TABLE(state char(2), city varchar(60), profit decimal(15, 2))
as
begin
	insert into @profitRanking
		select top 5 s_state, s_city, sum(ss_net_profit) as totalProfit 
		from store_sales_history, store, date_dim
		where ss_store_sk = s_store_sk
			and ss_sold_date_sk = d_date_sk
			and d_year = @givenYear
		group by s_state, s_city
		order by totalProfit desc;

	return;
end
go

--invocation query
SELECT date_dim.d_year,
		Results.state,
		Results.city,
		Results.profit
FROM date_dim
OUTER APPLY dbo.maxProfitStates(d_year) AS Results
where results.profit IS NOT NULL
group by d_year, Results.state, Results.city,
		Results.profit
order by d_year desc


