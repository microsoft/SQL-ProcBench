create or alter function maxPurchaseChannel(@ckey int, @fromDateSk int, @toDateSk int)
returns varchar(50) as
begin
	declare @numSalesFromStore int;
	declare @numSalesFromCatalog int;
	declare @numSalesFromWeb int;
	declare @maxChannel varchar(50);
	set @numSalesFromStore = (select count(*) 
							from store_sales_history
							where ss_customer_sk = @ckey and
							ss_sold_date_sk>=@fromDateSk and
							ss_sold_date_sk<=@toDateSk);
	
	set @numSalesFromCatalog = (select count(*) 
							from catalog_sales_history
							where cs_bill_customer_sk = @ckey and
							cs_sold_date_sk>=@fromDateSk and
							cs_sold_date_sk<=@toDateSk);
	
	set @numSalesFromWeb = (select count(*) 
							from web_sales_history
							where ws_bill_customer_sk = @ckey and
							ws_sold_date_sk>=@fromDateSk and
							ws_sold_date_sk<=@toDateSk);

	if(@numSalesFromStore>@numSalesFromCatalog)
	begin
		set @maxChannel = 'Store';
		if(@numSalesfromWeb>@numSalesFromStore)
		begin
			set @maxChannel = 'Web';
		end
	end
	else
	begin
		set @maxChannel = 'Catalog';
		if(@numSalesfromWeb>@numSalesFromCatalog)
		begin
			set @maxChannel = 'Web';
		end
	end
	
	return @maxChannel;									
end
go

--invocation query
select c_customer_sk, dbo.maxPurchaseChannel(c_customer_sk, 2000, 2020) as channel from customer
