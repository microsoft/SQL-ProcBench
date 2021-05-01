--highest profit earning promos on the catslog

create or replace function bestPromoCatalog()
returns TABLE(promo_sk int, profit_store decimal)
language plpgsql
as $$
begin
	return query
		select cs_promo_sk, sum(cs_net_profit) as posProfit from cataolog_sales_history
		where cs_net_profit>0
			and cs_promo_sk is not NULL
		group by cs_promo_sk
		order by posProfit desc
		limit 5;

end; $$