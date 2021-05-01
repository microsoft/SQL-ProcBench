--highest profit earning promos on the web

create or replace function bestPromoWeb()
returns TABLE(promo_sk int, profit_store decimal)
language plpgsql
as $$
begin
	return query
		select ws_promo_sk, sum(ws_net_profit) as posProfit from web_sales_history
		where ws_net_profit>0
			and ws_promo_sk is not NULL
		group by ws_promo_sk
		order by posProfit desc
		limit 5;

end; $$