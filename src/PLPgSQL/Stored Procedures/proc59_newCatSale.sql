--new catalog sale record.
create or alter procedure newCatalogSale(item_sk int, cust_sk int, custname char(10), page_sk int, promo_sk int, 
							  qty int, listPrice decimal(7, 2), sp decimal(7, 2), npaid decimal(7, 2), 
							  profit decimal(7, 2), streetnum char(10), suite char(10), city varchar(60),
								county varchar(30), state char(2), zip char(10))
language plpgsql
as $$
declare
	curDate date;
	dateSk int; hr int; mn int; sc int; timeSk int; addr_sk int;
	curTime time;
 	adr_id varchar(16); cus_id varchar(16);
	randomString VARCHAR(16);
begin
	hr := date_part('hour', (SELECT current_timestamp));
	mn := date_part('minute', (SELECT current_timestamp));
	sc := date_part('second', (SELECT current_timestamp));
	curDate := CURRENT_DATE;
	dateSk := (select d_date_sk from date_dim where d_date=curDate);
	timeSk := (select t_time_sk from time_dim where t_hour= hr and t_minute=mn and t_second=sc);
	
	--this is a new customer
	if(cust_sk=NULL) then
		cust_sk := (select max(c_customer_sk)+1 from customer);
		addr_sk := (select max(ca_address_sk)+1 from customer_address);

		call CreateRandomString (randomString);
		adr_id :=  randomString;

		insert into customer_address(ca_address_sk, ca_address_id, ca_street_number, ca_suite_number, 
									ca_city, ca_county, ca_state, ca_zip)
		values (addr_sk, adr_id, streetnum, suite, city, county, st, zip);

		call CreateRandomString (randomString);
		cus_id :=  randomString;

		insert into customer(c_customer_sk, c_customer_id, c_first_name, c_current_addr_sk)
		values (cust_sk, cus_id, custname, addr_sk);

	else
		addr_sk := (select c_current_addr_sk from customer where c_customer_sk=cust_sk);
	end if;

	insert into catalog_sales (cs_sold_date_sk, cs_sold_time_sk, cs_item_sk, cs_bill_customer_sk, cs_ship_addr_sk, cs_catalog_page_sk,
							cs_promo_sk, cs_order_number, cs_quantity, cs_list_price, cs_sales_price, cs_net_paid, cs_net_profit)
	values (dateSk, timeSk, item_sk, cust_sk, addr_sk, page_sk, promo_sk, ordr, qty, listPrice, sp, npaid, profit);
end