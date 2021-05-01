--new web sale record.
create or replace procedure newWebSale(item_sk int, cust_sk IN OUT int, custname char, page_sk int, promo_sk int, 
							  qty int, listPrice number, sp number, npaid number, ordr int,
							  profit number, streetnum char, suite char, city varchar,
								county varchar2, st char, zip char)
is
	curDate date;
	dateSk int; hr int; mn int; sc int; timeSk int; addr_sk int;
	curTime timestamp;
 	adr_id varchar(16); cus_id varchar(16);
	randomString VARCHAR(16);
begin
    SELECT EXTRACT(HOUR FROM SYSTIMESTAMP) into hr FROM DUAL;
    SELECT EXTRACT(MINUTE FROM SYSTIMESTAMP) into mn FROM DUAL;
    SELECT EXTRACT(SECOND FROM SYSTIMESTAMP) into sc FROM DUAL;
    select sysdate into curDate from dual;
	select d_date_sk into dateSk from date_dim where d_date=curDate;
	select t_time_sk into timeSk from time_dim where t_hour= hr and t_minute=mn and t_second=sc;
	
	--this is a new customer
	if(cust_sk=NULL) then
		select max(c_customer_sk)+1 into cust_sk from customer;
		select max(ca_address_sk)+1 into addr_sk from customer_address;

		CreateRandomString (randomString);
		adr_id :=  randomString;

		insert into customer_address(ca_address_sk, ca_address_id, ca_street_number, ca_suite_number, 
									ca_city, ca_county, ca_state, ca_zip)
		values (addr_sk, adr_id, streetnum, suite, city, county, st, zip);

		CreateRandomString (randomString);
		cus_id :=  randomString;

		insert into customer(c_customer_sk, c_customer_id, c_first_name, c_current_addr_sk)
		values (cust_sk, cus_id, custname, addr_sk);

	else
		select c_current_addr_sk into addr_sk from customer where c_customer_sk=cust_sk;
	end if;

	insert into web_sales (ws_sold_date_sk, ws_sold_time_sk, ws_item_sk, ws_bill_customer_sk, ws_ship_addr_sk, ws_web_page_sk,
							ws_promo_sk, ws_order_number,  ws_quantity, ws_list_price, ws_sales_price, ws_net_paid, ws_net_profit)
	values (dateSk, timeSk, item_sk, cust_sk, addr_sk, page_sk, promo_sk, ordr, qty, listPrice, sp, npaid, profit);
end; 