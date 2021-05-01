CREATE function warehouseAddress_Get (warehouseId char(16))
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for
    select w_warehouse_name, w_street_number, w_street_name, w_suite_number, w_city, w_county, w_state, w_zip, w_country
	FROM warehouse
	where w_warehouse_id = warehouseId;
	
	return c1;
END; $$
language plpgsql