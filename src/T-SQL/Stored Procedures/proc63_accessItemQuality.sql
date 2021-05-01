create or alter procedure AccessItemQuality
as
begin
	declare @mostReturnItem table(itemNo int, manufactId int);
	insert into @mostReturnItem select * from dbo.MaxRetunItems();
	delete from item where i_item_sk in (select itemNo from @mostReturnItem);   --these items deleted
	update item set i_item_desc = 'HIGH RISH ITEM' where i_manufact_id in (select manufactId from @mostReturnItem);
end