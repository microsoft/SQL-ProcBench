create or replace function preferredChannel_wrtCount(cust_key int)
return varchar
is
    numWeb number;
    numStore number;
    numCat number;
begin
	numWeb :=0;
	numStore :=0;
	numCat :=0;
	select count(*) into numWeb from web_sales_history where ws_bill_customer_sk=cust_key;
	select count(*) into numStore from store_sales_history where ss_customer_sk=cust_key;
	select count(*) into numCat from catalog_sales_history where cs_bill_customer_sk=cust_key;
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

select c_customer_sk, dbo.preferredChannel(c_customer_sk) from customer;