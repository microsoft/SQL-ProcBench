--process cancellation of an order fromm web and record reason in the reason table. 

create or alter procedure webOrderCancellation (@item_sk int, @orderNo int, @reasonId int)
as
begin
	declare @soldDate date, @curDate date;
	declare @dateDiff int, @reasonSk int;
	declare @id VARCHAR(16);

	if not exists (select * from web_sales where ws_item_sk=@item_sk and ws_order_number=@orderNo)
	begin
		RAISERROR ('invalid order', 16, 10);
		return;
	end

	set @soldDate = (select d_date from web_sales, date_dim 
					where ws_sold_date_sk=d_date_sk and ws_item_sk=@item_sk and ws_order_number=@orderNo);
	set @dateDiff = DATEDIFF(day,  @soldDate, GETDATE());
	if(@dateDiff>30)
	begin
		RAISERROR ('Item not eligible for return',16,10);
		return;
	end
	else
	begin
		delete from web_sales where ws_item_sk=@item_sk and ws_order_number=@orderNo;
		if exists (select * from reason where r_reason_sk=@reasonId)
			return;
		else
		begin
			set @reasonSk = (select max(r_reason_sk)+1 from reason);
			EXEC dbo.CreateRandomString @id OUTPUT;
			insert into reason (r_reason_sk, r_reason_id) values (@reasonSk, @id);
		end
	end
end

