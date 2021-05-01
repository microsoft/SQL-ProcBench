--process cancellation of an order from catalog and record reason in the reason table. 
create or alter procedure catalogOrderCancellation (@item_sk int, @orderNo int, @reasonId int)
as
begin
	declare @shipDate date, @curDate date;
	declare @dateDiff int, @reasonSk int;
	declare @id VARCHAR(16);

	if not exists (select * from catalog_sales where cs_item_sk=@item_sk and cs_order_number=@orderNo)
	begin
		RAISERROR ('invalid order', 16, 10);  --no such order exists.
		return;
	end

	set @shipDate = (select d_date from catalog_sales, date_dim 
					where cs_ship_date_sk=d_date_sk and cs_item_sk=@item_sk and cs_order_number=@orderNo);
	set @dateDiff = DATEDIFF(day,  @shipDate, GETDATE());
	if(@dateDiff>=0)   --shipdate<=today's date
	begin
		RAISERROR ('Item already shipped and cannot be cancelled. Try returning instead.',16,10);
		return;
	end
	else
	begin
		delete from catalog_sales where cs_item_sk=@item_sk and cs_order_number=@orderNo;
		if exists (select * from reason where r_reason_sk=@reasonId)
			return;
		else
		begin
			set @reasonSk = (select max(r_reason_sk)+1 from reason);
			EXEC dbo.CreateRandomString @id OUTPUT;
			--set @id = 'ABCDEFSDRGFTDVGF';
			insert into reason (r_reason_sk, r_reason_id) values (@reasonSk, @id);
		end
	end
end

--invocation query
exec dbo.catalogOrderCancellation 7273, 169579, 57
go