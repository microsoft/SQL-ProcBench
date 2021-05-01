create or alter function getManufact_complex(@item int)
returns char(50)
as
begin
	declare @man char (50) = '';  
	declare @cnt1 int, @cnt2 int;
	-- was this item sold in this year through store or catalog?
	set @cnt1 = (select count(*) from store_sales_history, date_dim where ss_item_sk=@item and d_date_sk=ss_sold_date_sk and d_year=2003);
	set @cnt2  = (select count(*) from catalog_sales_history, date_dim where cs_item_sk=@item and d_date_sk=cs_sold_date_sk and d_year=2003);
	if(@cnt1>0 and @cnt2>0)
	begin
		set @man = (select i_manufact from item where i_item_sk = @item);
	end
	else
		set @man = 'outdated item'; --implies that this item is not sold in a recent year at all and is probably outdated
	return @man;
end
go

--Complex Calling Query
select maxsoldItem 
from
(select top 50000 ss_item_sk as maxSoldItem 
from 
	(select ss_item_sk, sum(cnt) totalCnt
	from
		(select ss_item_sk, count(*) cnt from dbo.store_sales_history group by ss_item_sk 
		union all
		select cs_item_sk, count(*) cnt from dbo.catalog_sales_history group by cs_item_sk
		union all
		select ws_item_sk, count(*) cnt from dbo.web_sales_history group by ws_item_sk )t1
	group by ss_item_sk)t2
order by totalCnt desc
)t3
where dbo.getManufact_complex(maxSoldItem) = 'oughtn st';

--Simple Calling Query
select ws_item_sk 
from
	(select top 25000 ws_item_sk, count(*) cnt from dbo.web_sales group by ws_item_sk order by cnt)t1
where dbo.getManufact_complex(ws_item_sk) = 'oughtn st';