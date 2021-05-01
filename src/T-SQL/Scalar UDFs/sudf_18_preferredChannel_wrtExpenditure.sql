--for all customers, find out the preferred channel wrt money spent.
create or alter function preferredChannel_wrtExpenditure(@cust_key int)
returns varchar(50)
as
begin
	declare @numWeb decimal(15, 2)=0;
	declare @numStore decimal(15, 2)=0;
	declare @numCat decimal(15, 2)=0;
	if exists (select * from web_sales_history where ws_bill_customer_sk=@cust_key)
		set @numWeb = (select sum(ws_net_paid_inc_ship_tax) from web_sales_history where  ws_bill_customer_sk=@cust_key);
	if exists (select * from store_sales_history where ss_customer_sk=@cust_key)
		set @numStore = (select sum(ss_net_paid_inc_tax) from store_sales_history where  ss_customer_sk=@cust_key);
	if exists (select * from catalog_sales_history where cs_bill_customer_sk=@cust_key)
		set @numCat = (select sum(cs_net_paid_inc_ship_tax) from catalog_sales_history where  cs_bill_customer_sk=@cust_key);
	if(@numWeb>=@numStore and @numWeb>=@numCat)
		return 'web';
	if(@numStore>=@numWeb and @numStore>=@numCat)
		return 'store';
	if(@numCat>=@numStore and @numCat>=@numWeb)
		return 'Catalog';
	return 'Logical error';
end
go

--invocation Query
select c_customer_sk, dbo.preferredChannel_wrtExpenditure(c_customer_sk) from customer;
