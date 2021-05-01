--for all customers, find out the preferred channel wrt number of orders made.

create or alter function preferredChannel_wrtCount(@cust_key int)
returns varchar(50)
as
begin
	declare @numWeb int=0;
	declare @numStore int=0;
	declare @numCat int=0;
	set @numWeb = (select count(*) from web_sales_history where  ws_bill_customer_sk=@cust_key);
	set @numStore = (select count(*) from store_sales_history where  ss_customer_sk=@cust_key);
	set @numCat = (select count(*) from catalog_sales_history where  cs_bill_customer_sk=@cust_key);
	if(@numWeb>=@numStore and @numWeb>=@numCat)
		return 'web';
	if(@numStore>=@numWeb and @numStore>=@numCat)
		return 'store';
	if(@numCat>=@numStore and @numCat>=@numWeb)
		return 'Catalog';
	return 'Logical error';
end
go

--invocation query
select c_customer_sk, dbo.preferredChannel(c_customer_sk) from customer;