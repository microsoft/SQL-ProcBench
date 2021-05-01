--Compute the total discount on web sales of items from a given manufacturer for
--sales whose discount exceeded 30% over the average discount of items from that manufacturer.

create or alter function totalDiscount (@manufacture_id int)
returns decimal(15,2)
as
begin
	declare @avg decimal(15,2);
	declare @s decimal(15, 2);
	set @avg = (select avg(ws_ext_discount_amt) from web_sales_history, item 
				where ws_item_sk = i_item_sk and i_manufact_id = @manufacture_id);

	set @s = (select sum(ws_ext_discount_amt) from web_sales_history, item 
					where ws_item_sk = i_item_sk and i_manufact_id = @manufacture_id and
					ws_ext_discount_amt>1.3*@avg);
	return @s;	
end
go

select distinct i_manufact_id, dbo.totalDiscount(i_manufact_id) as totalDisc from item;