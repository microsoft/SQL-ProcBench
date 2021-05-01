--add a new warehouse to the database:
create or alter procedure newWarehouse(@name varchar(20), @sqFt int, @streetNo char(10), @stName varchar(60),
										@suite char(10),@city varchar(60), @county varchar(30), @state char(2), 
										@zip char(10), @country varchar(20))
as
begin
	declare @randomString char(16);
	declare @sk int;
	declare @id char(16);
	set @sk = (select max(w_warehouse_sk)+1 from warehouse );
	
	EXEC dbo.CreateRandomString @randomString OUTPUT;
	set @id = @randomString;
	insert into warehouse (w_warehouse_sk, w_warehouse_id, w_warehouse_name, w_warehouse_sq_ft, w_street_number,
							w_street_name, w_suite_number, w_city, w_county, w_state, w_zip, w_country)
			values (@sk, @id, @name, @sqFt, @streetNo, @stName, @suite, @city, @county, @state, @zip, @country);

end