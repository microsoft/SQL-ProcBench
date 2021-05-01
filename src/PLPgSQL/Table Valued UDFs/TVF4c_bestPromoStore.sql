--highest profit earning promos through stores

create or replace function bestPromoStore()
returns TABLE(promo_sk int, profit_store decimal)
language plpgsql
as $$
begin
	return query
		select ss_promo_sk, sum(ss_net_profit) as posProfit from store_sales_history
		where ss_net_profit>0
			and ss_promo_sk is not NULL
		group by ss_promo_sk
		order by posProfit desc
		limit 5;

end; $$

