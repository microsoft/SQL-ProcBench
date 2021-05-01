-- Track the sale of a particular item through catalog for 2 consecutive years.
create or alter procedure trackSale_cat (@item int)
as
begin
	set nocount on;

	declare @compareTable table (mnth_cmpr int, sale_2001 int, sale_2002 int);
	declare @firstYr table (mnth int, sale_01 int);
	declare @secYr table (mnth int, sale_02 int);
	declare @month int, @sale int;

	insert into @firstYr
	select d_moy, count(*) as sl_01 from catalog_sales, date_dim 
	where cs_sold_date_sk = d_date_sk and d_year = 2001 and cs_item_sk = @item
	group by d_moy;

	insert into @secYr
	select d_moy, count(*) as sl_02 from catalog_sales, date_dim 
	where cs_sold_date_sk = d_date_sk and d_year = 2002 and cs_item_sk = @item
	group by d_moy;

	insert into @compareTable(mnth_cmpr, sale_2001) select * from @firstYr;

	declare c1 cursor for select * from @secYr;
	open c1;
	fetch next from c1 into @month, @sale;
	while(@@FETCH_STATUS=0)
	begin
		update @compareTable set sale_2002 = @sale where mnth_cmpr= @month;
		fetch next from c1 into @month, @sale;
	end
	close c1;
	deallocate c1;
	
	select * from @compareTable order by mnth_cmpr;
end
