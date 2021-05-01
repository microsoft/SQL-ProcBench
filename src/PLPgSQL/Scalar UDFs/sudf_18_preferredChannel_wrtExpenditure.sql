--for all customers, find out the preferred channel wrt money spent.
create or replace function preferredChannel_wrtExpenditure(cust_key int)
returns varchar(50)
language plpgsql
as
$$
declare
	numWeb decimal;
	numStore decimal;
	numCat decimal;
begin 
	numWeb:=0; numStore:=0; numCat:=0;
	if exists (select * from web_sales_history where ws_bill_customer_sk=cust_key) then
		numWeb := (select sum(ws_net_paid_inc_ship_tax) from web_sales_history where  ws_bill_customer_sk=cust_key);
	end if;
	if exists (select * from store_sales_history where ss_customer_sk=cust_key) then
		numStore := (select sum(ss_net_paid_inc_tax) from store_sales_history where  ss_customer_sk=cust_key);
	end if;
	if exists (select * from catalog_sales_history where cs_bill_customer_sk=cust_key) then
		numCat := (select sum(cs_net_paid_inc_ship_tax) from catalog_sales_history where  cs_bill_customer_sk=cust_key);
	end if;
	if(numWeb>=numStore and numWeb>=numCat) then
		return 'web';
	end if;
	if(numStore>=numWeb and numStore>=numCat) then
		return 'store';
	end if;
	if(numCat>=numStore and numCat>=numWeb) then
		return 'Catalog';
	end if;
	return 'Logical error';
end; $$

--invocation Query
select c_customer_sk, preferredChannel_wrtExpenditure(c_customer_sk) from customer;
