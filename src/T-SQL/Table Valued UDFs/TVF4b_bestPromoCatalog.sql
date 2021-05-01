--highest profit earning promos on the catalog

create or alter function bestPromosCatalog()
returns @bestPromoCat TABLE(promo_sk int, profit_cat decimal(15,2))
as
begin

	insert into @bestPromoCat
		select top 5 cs_promo_sk, sum(cs_net_profit) as posProfit from catalog_sales_history
		where cs_net_profit>0
			and cs_promo_sk is not NULL
		group by cs_promo_sk
		order by posProfit desc

	return;

end
go