CREATE or REPLACE TYPE bestPromo_o IS object(
   promo_sk number, profit_store number
);
/

Create or REPLACE type bestPromo_t is TABLE OF bestPromo_o;

create or replace function bestPromosCatalog
return bestPromo_t
is
    promoTable bestPromo_t;
begin

    select bestPromo_o(t.cs_promo_sk, t.posProfit)
    bulk collect into promoTable
    from 
		(select cs_promo_sk, sum(cs_net_profit) as posProfit 
        from catalog_sales_history
		where cs_net_profit>0
			and cs_promo_sk is not NULL
		group by cs_promo_sk
		order by posProfit desc)t
    where rownum<=5;
    
	return promoTable;

end;




