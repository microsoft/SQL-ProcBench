--for all customers, find out the preferred channel wrt number of orders made.

create or replace function preferredChannel_wrtCount(cust_key int)
returns varchar(50)
language plpgsql
as
$$
declare
    numWeb int;
    numStore int;
    numCat int;
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
$$;

--inovocation query
select c_customer_sk, preferredChannel_wrtCount(c_customer_sk) from customer;