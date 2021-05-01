create or replace function getManufact_simple(itm int)
returns char(50)
language plpgsql
as
$$
begin
	return (select i_manufact from item where i_item_sk = itm);
end; $$


--complex calling query
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
where getManufact_simple(maxSoldItem) = 'oughtn st';


--Simple Calling Query
select ws_item_sk 
from
	(select ws_item_sk, count(*) cnt from web_sales group by ws_item_sk order by cnt limit 25000)t1
where getManufact_simple(ws_item_sk) = 'oughtn st';