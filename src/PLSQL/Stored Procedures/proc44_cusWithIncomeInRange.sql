--List all customers living in a specified city, in a given income band
create or replace procedure cusWithIncomeInRange(city varchar, givenIb int)
as 
	cust int; ib int; hhd int;
	cursor c1 is 
        select c_customer_sk 
        from customer, customer_address 
        where c_current_addr_sk=ca_address_sk and ca_city = city;
begin
	open c1;
    loop
	fetch c1 into cust;
         exit when c1%NOTFOUND;
		select c_current_hdemo_sk into hhd from customer where c_customer_sk = cust;
		select hd_income_band_sk into ib from household_demographics where hd_demo_sk = hhd;
		if(ib = givenIb) then
			dbms_output.put_line(cust);
		end if;
		fetch  c1 into cust;
	end loop;
end;

--execution query
call cusWithIncomeInRange ('Hopewell', 2)

