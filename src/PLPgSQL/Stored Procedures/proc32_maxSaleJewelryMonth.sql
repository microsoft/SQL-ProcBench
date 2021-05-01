--which months registered the highest sale of jewelry for 3 year period startig at the given year.

create or replace function maxSaleJewelryMonth(yr int)
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
	month1 int;  month2 int;  month3 int;
begin
	month1 := (select d_moy
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year =  yr and i_category='jewelry'
	group by d_moy
	order by count(*) desc 
	limit 1);

	month2 := (select  d_moy
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year =  yr+1 and i_category='jewelry'
	group by d_moy
	order by count(*) desc
	limit 1);

	month3 := (select d_moy
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year =  yr+2 and i_category='jewelry'
	group by d_moy
	order by count(*) desc
	limit 1);
	
	open c1 for 
	select  month1,  month2,  month3;
	
	return c1;
end; $$
language plpgsql
