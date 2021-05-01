--extract ship mode information for a given order.

create or replace function  getShipMode(item int, ordr int, channel char(1))
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor'; 
begin
	if(channel is NULL) then
		if exists (select * from web_sales where ws_item_sk=item and ws_order_number=ordr) then
			if exists (select * from catalog_sales where cs_item_sk=item and cs_order_number=ordr) then
				raise exception 'ambiguous channel for this order';
			else	
				open c1 for
				select sm_type from web_sales, ship_mode where ws_item_sk=item and ws_order_number=ordr and ws_ship_mode_sk = sm_ship_mode_sk;
			end if;
		else
			if not exists (select * from catalog_sales where cs_item_sk=item and cs_order_number=ordr) then
				raise exception 'Order not found in any chanel';
			else
				open c1 for
				select sm_type from catalog_sales, ship_mode where cs_item_sk=item and cs_order_number=ordr and cs_ship_mode_sk = sm_ship_mode_sk;
			end if;
		end if;

	elsif (channel='w') then
		if not exists (select * from web_sales where ws_item_sk=item and ws_order_number=ordr) then
			raise exception 'order not foud in web';
		else
			open c1 for
			select sm_type from web_sales, ship_mode where ws_item_sk=item and ws_order_number=ordr and ws_ship_mode_sk = sm_ship_mode_sk;
		end if;

	elsif (channel='c') then
		if not exists (select * from catalog_sales where cs_item_sk=item and cs_order_number=ordr) then
			raise exception 'order not foud in catalog';
		else 
			open c1 for
			select sm_type from catalog_sales, ship_mode where cs_item_sk=item and cs_order_number=ordr and cs_ship_mode_sk = sm_ship_mode_sk;
		end if;
	end if;
	
	return c1;
end; $$
language plpgsql

--invocation query example
select getShipMode(31714, 485252, NULL);
fetch all from mycursor;