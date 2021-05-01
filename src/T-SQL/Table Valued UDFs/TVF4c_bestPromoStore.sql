--highest profit earning promos through stores

create or alter function bestPromoStore()
returns @bestPromoStore TABLE(promo_sk int, profit_store decimal(15,2))
as
begin

	insert into @bestPromoStore
		select top 5 ss_promo_sk, sum(ss_net_profit) as posProfit from store_sales_history
		where ss_net_profit>0
			and ss_promo_sk is not NULL
		group by ss_promo_sk
		order by posProfit desc

	return;

end
go