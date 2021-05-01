--highest profit earning promos on the web

create or alter function bestPromosWeb()
returns @bestPromoWeb TABLE(promo_sk int, profit_web decimal(15,2))
as
begin

	insert into @bestPromoWeb
		select top 5 ws_promo_sk, sum(ws_net_profit)  as posProfit from web_sales_history
		where ws_net_profit>0
			and ws_promo_sk is not NULL
		group by ws_promo_sk
		order by posProfit desc

	return;
end
go