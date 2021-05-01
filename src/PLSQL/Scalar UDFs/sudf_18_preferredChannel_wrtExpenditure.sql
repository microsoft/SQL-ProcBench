--for all customers, find out the preferred channel wrt money spent.
create or replace function preferredChannel_wrtExpenditure(cust_key int)
return varchar
is
    numWeb number;
    numStore number;
    numCat number;
    existsCat number;
    existsStore number;
    existsWeb number;
begin
	numWeb :=0;
	numStore :=0;
	numCat :=0;
    select count(*) into existsWeb from web_sales_history where ws_bill_customer_sk=cust_key;
    select count(*) into existsStore from store_sales_history where ss_customer_sk=cust_key;
    select count(*) into existsCat from catalog_sales_history where cs_bill_customer_sk=cust_key;
	if (existsWeb>0) then
		select  sum(ws_net_paid_inc_ship_tax) into numWeb from web_sales_history where ws_bill_customer_sk=cust_key;
    end if;
	if (existsStore>0) then
		select sum(ss_net_paid_inc_tax) into numStore from store_sales_history where  ss_customer_sk=cust_key;
    end if;
	if (existsCat>0) then
		select sum(cs_net_paid_inc_ship_tax) into numCat from catalog_sales_history where  cs_bill_customer_sk=cust_key;
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
end;

--invocation Query
select c_customer_sk, dbo.preferredChannel_wrtExpenditure(c_customer_sk) from customer;
