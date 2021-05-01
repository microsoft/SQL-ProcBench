-- Customers who spend more money online than in stores

create or replace procedure moreOnlineThanStore()
language plpgsql
as $$
declare
	preferredChannel varchar(50);
	cust int;
	c1 cursor is (select c_customer_sk from customer);
begin
	open c1;
	fetch c1 into cust;
	while found loop
		preferredChannel := (select preferredChannel_wrtExpenditure(cust));
		if(preferredChannel='catalog' or preferredChannel='web') then
			raise notice '%', cust;
		end if;
		fetch  c1 into cust;
	end loop;
end; $$