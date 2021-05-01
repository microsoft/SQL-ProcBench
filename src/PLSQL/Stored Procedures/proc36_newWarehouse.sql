--add a new warehouse to the database:
create or replace procedure newWarehouse( nm varchar,  sqFt int,  streetNo char,  stName varchar,
										 suite char, city varchar,  county varchar,  st char, 
										 zip char,  country varchar)
is
	randomString varchar(16);
	ske int;
	ide char(16);
begin
	select max(w_warehouse_sk)+1 into ske from warehouse;
	
	CreateRandomString (randomString);
	ide :=  randomString;
	insert into warehouse (w_warehouse_sk, w_warehouse_id, w_warehouse_name, w_warehouse_sq_ft, w_street_number,
							w_street_name, w_suite_number, w_city, w_county, w_state, w_zip, w_country)
			values ( ske,  ide,  nm,  sqFt,  streetNo,  stName,  suite,  city,  county,  st,  zip,  country);

end; 