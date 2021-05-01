--add a new warehouse to the database:
create or replace procedure newWarehouse( nm varchar(20),  sqFt int,  streetNo char(10),  stName varchar(60),
										 suite char(10), city varchar(60),  county varchar(30),  st char(2), 
										 zip char(10),  country varchar(20))
language plpgsql
as $$
declare
	randomString varchar(16);
	sk int;
	ide char(16);
begin
	sk := (select max(w_warehouse_sk)+1 from warehouse );
	
	call CreateRandomString (randomString);
	ide :=  randomString;
	insert into warehouse (w_warehouse_sk, w_warehouse_id, w_warehouse_name, w_warehouse_sq_ft, w_street_number,
							w_street_name, w_suite_number, w_city, w_county, w_state, w_zip, w_country)
			values ( sk,  ide,  nm,  sqFt,  streetNo,  stName,  suite,  city,  county,  st,  zip,  country);

end; $$