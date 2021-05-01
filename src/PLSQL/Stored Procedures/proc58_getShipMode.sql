--extract ship mode information for a given order.

create or replace procedure getShipMode(item int, ordr int, channel char)
as 
    c1 sys_refcursor; 
    cntWeb int; cntCat int;
begin
    select count(*) into cntWeb from web_sales where ws_item_sk=item and ws_order_number=ordr;
    select count(*) into cntCat from catalog_sales where cs_item_sk=item and cs_order_number=ordr;
	if(channel is NULL) then
		if (cntWeb>0) then
			if (cntCat>0) then
				raise_application_error(-20111, 'ambiguous channel for this order');
			else
                open c1 for
                    select sm_type from web_sales, ship_mode where ws_item_sk=item and ws_order_number=ordr and ws_ship_mode_sk = sm_ship_mode_sk;
            end if;
		else
			if (cntCat=0) then
				raise_application_error(-20111,'Order not found in any chanel');
			else
                open c1 for
                    select sm_type from catalog_sales, ship_mode where cs_item_sk=item and cs_order_number=ordr and cs_ship_mode_sk = sm_ship_mode_sk;
            end if;
		end if;

	elsif (channel='w') then
		if (cntWeb=0) then
			raise_application_error(-20111,'order not foud in web');
		else
            open c1 for 
                select sm_type from web_sales, ship_mode where ws_item_sk=item and ws_order_number=ordr and ws_ship_mode_sk = sm_ship_mode_sk;
        end if;

	elsif (channel='c') then
		if (cntCat=0) then
			raise_application_error(-20111,'order not foud in catalog');
		else 
            open c1 for
                select sm_type from catalog_sales, ship_mode where cs_item_sk=item and cs_order_number=ordr and cs_ship_mode_sk = sm_ship_mode_sk;
        end if;
	end if;
    dbms_sql.return_result(c1);
end;

--invocation example
call getShipMode (31714, 485252, NULL);
