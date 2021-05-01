--List all customers living in a specified city, in a given income band

create or alter procedure cusWithIncomeInRange(@city varchar(60), @givenIb int)
as
begin
	declare @cust int, @ib int, @hhd int;
	declare c1 cursor for (select c_customer_sk from customer, customer_address 
							where c_current_addr_sk=ca_address_sk and ca_city = @city);
	open c1;
	fetch next from c1 into @cust;
	while(@@FETCH_STATUS=0)
	begin
		set @hhd = (select c_current_hdemo_sk from customer where c_customer_sk = @cust);
		set @ib = (select hd_income_band_sk from household_demographics where hd_demo_sk=@hhd);
		if(@ib = @givenIb)
			print (@cust);
		fetch next from c1 into @cust;
	end
end

--invocation query
exec dbo.cusWithIncomeInRange Hopewell, 2