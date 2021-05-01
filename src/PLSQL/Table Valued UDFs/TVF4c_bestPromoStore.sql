CREATE or REPLACE TYPE bestPromo_o IS object(
   promo_sk number, profit_store number
);
/

Create or REPLACE type bestPromo_t is TABLE OF bestPromo_o;

create or replace function bestPromoStore
return bestPromo_t
is
    promoTable bestPromo_t;
begin

    select bestPromo_o(t.ss_promo_sk, t.posProfit)
    bulk collect into promoTable
    from        
		(select ss_promo_sk, sum(ss_net_profit) as posProfit 
        from store_sales_history
		where ss_net_profit>0
			and ss_promo_sk is not NULL
		group by ss_promo_sk
		order by posProfit desc)t
    where rownum<=5;
    
	return promoTable;

end;





