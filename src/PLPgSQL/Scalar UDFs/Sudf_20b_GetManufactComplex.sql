create or replace function getManufact_complex(itm int)
returns char(50)
language plpgsql
as
$$
declare
	man char(50);
	cnt1 int; cnt2 int;
begin
	man  := '';  
	-- was this item sold in this year through store or catalog?
	cnt1 := (select count(*) from store_sales_history, date_dim where ss_item_sk=itm and d_date_sk=ss_sold_date_sk and d_year=2003);
	cnt2  := (select count(*) from catalog_sales_history, date_dim where cs_item_sk=itm and d_date_sk=cs_sold_date_sk and d_year=2003);
	if(cnt1>0 and cnt2>0) then
		man := (select i_manufact from item where i_item_sk = itm);
	else
		man := 'outdated item'; --implies that this item is not sold in a recent year at all and is probably outdated
	end if;
	return man;
end; $$

--Complex Calling Query
select maxsoldItem 
from
(select ss_item_sk as maxSoldItem 
from 
	(select ss_item_sk, sum(cnt) totalCnt
	from
		(select ss_item_sk, count(*) cnt from store_sales_history group by ss_item_sk 
		union all
		select cs_item_sk, count(*) cnt from catalog_sales_history group by cs_item_sk
		union all
		select ws_item_sk, count(*) cnt from web_sales_history group by ws_item_sk )t1
	group by ss_item_sk)t2
order by totalCnt desc
limit 25000
)t3
where getManufact_complex(maxSoldItem) = 'oughtn st';

--Simple Calling Query
select ws_item_sk 
from
	(select ws_item_sk, count(*) cnt from web_sales group by ws_item_sk order by cnt limit 25000 )t1
where getManufact_complex(ws_item_sk) = 'oughtn st';