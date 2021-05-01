--extract ship mode information for a given order.

create or alter procedure getShipMode(@item int, @order int, @channel char(1))
as 
begin
	if(@channel is NULL)
	begin
		if exists (select * from web_sales where ws_item_sk=@item and ws_order_number=@order) 
		begin
			if exists (select * from catalog_sales where cs_item_sk=@item and cs_order_number=@order)
				RAISERROR('ambiguous channel for this order', 10, 16);
			else
				select sm_type from web_sales, ship_mode where ws_item_sk=@item and ws_order_number=@order and ws_ship_mode_sk = sm_ship_mode_sk;
		end
		else
		begin
			if not exists (select * from catalog_sales where cs_item_sk=@item and cs_order_number=@order)
				RAISERROR('Order not found in any chanel', 10, 16);
			else
				select sm_type from catalog_sales, ship_mode where cs_item_sk=@item and cs_order_number=@order and cs_ship_mode_sk = sm_ship_mode_sk;
		end
	end

	else if (@channel='w')
	begin
		if not exists (select * from web_sales where ws_item_sk=@item and ws_order_number=@order) 
			RAISERROR('order not foud in web', 10, 16);
		else
			select sm_type from web_sales, ship_mode where ws_item_sk=@item and ws_order_number=@order and ws_ship_mode_sk = sm_ship_mode_sk;
	end

	else if (@channel='c')
	begin
		if not exists (select * from catalog_sales where cs_item_sk=@item and cs_order_number=@order)
			RAISERROR('order not foud in catalog', 10, 16);
		else 
			select sm_type from catalog_sales, ship_mode where cs_item_sk=@item and cs_order_number=@order and cs_ship_mode_sk = sm_ship_mode_sk;
	end
end

--invocation example
exec dbo.getShipMode 31714, 485252, NULL
go
