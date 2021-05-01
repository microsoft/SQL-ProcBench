--which months registered the highest store sale of electronics for a given 3 year period.

--which months registered the highest sale of electronics for 3 year period startig at the given year.

create or alter procedure maxSaleElectronicsMonth(@year int)
as
begin
	declare @month1 int, @month2 int, @month3 int;

	set @month1 = (select top 1 d_moy
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year = @year and i_category='Electronics'
	group by d_moy
	order by count(*) desc);

	set @month2= (select top 1 d_moy
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year = @year+1 and i_category='Electronics'
	group by d_moy
	order by count(*) desc);

	set @month3 = (select top 1 d_moy
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year = @year+2 and i_category='Electronics'
	group by d_moy
	order by count(*) desc);

	select @month1 as year1 , @month2 as year2 , @month3 as year3;
end