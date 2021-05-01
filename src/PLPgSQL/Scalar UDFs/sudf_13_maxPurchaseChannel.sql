create or replace function maxPurchaseChannel(ckey int, fromDateSk int, toDateSk int)
returns varchar (50)
language plpgsql
as
$$
declare
 numSalesFromStore int;
 numSalesFromCatalog int;
 numSalesFromWeb int;
 maxChannel varchar(50);
begin
	select count(*) into numSalesFromStore
							from store_sales_history
							where ss_customer_sk = ckey and
							ss_sold_date_sk>=fromDateSk and
							ss_sold_date_sk<=toDateSk;
	
	select count(*) into numSalesFromCatalog
							from catalog_sales_history
							where cs_bill_customer_sk = ckey and
							cs_sold_date_sk>=fromDateSk and
							cs_sold_date_sk<=toDateSk;
	
	select count(*) into numSalesFromWeb
							from web_sales_history
							where ws_bill_customer_sk = ckey and
							ws_sold_date_sk>=fromDateSk and
							ws_sold_date_sk<=toDateSk;

	if(numSalesFromStore>numSalesFromCatalog)then
        maxChannel := 'Store';
		if(numSalesfromWeb>numSalesFromStore)then
			maxChannel := 'Web';
        end if;
	else
		maxChannel := 'Catalog';
		if(numSalesfromWeb>numSalesFromCatalog)then
			maxChannel := 'Web';
		end if;
	end if;
	
	return maxChannel;									
end;
$$;

select c_customer_sk, maxPurchaseChannel(c_customer_sk, 2000, 2020) as channel from customer