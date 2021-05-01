--List all customers living in a specified city, in a given income band
create or replace procedure cusWithIncomeInRange(city varchar(60), givenIb int)
language plpgsql
as $$
declare
	cust int; ib int; hhd int;
	c1 cursor is (select c_customer_sk from customer, customer_address 
							where c_current_addr_sk=ca_address_sk and ca_city = city);
begin
	open c1;
	fetch c1 into cust;
	while found loop
		hhd := (select c_current_hdemo_sk from customer where c_customer_sk = cust);
		ib := (select hd_income_band_sk from household_demographics where hd_demo_sk=hhd);
		if(ib = givenIb) then
			raise notice '%', cust;
		end if;
		fetch  c1 into cust;
	end loop;
end; $$

--execution query
call cusWithIncomeInRange ('Hopewell', 2)