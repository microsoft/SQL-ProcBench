--which months registered the highest sale of jewelry for 3 year period startig at the given year.

create or replace procedure maxSaleJewelryMonth(yr int)
as 
    c1 sys_refcursor; 
	month1 int;  month2 int;  month3 int;
    yr1 int; yr2 int; yr3 int;
begin
	select d_moy into month1
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year =  yr and i_category='jewelry'
	group by d_moy
	order by count(*) desc 
	fetch first 1 rows only;

	select  d_moy into month2
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year =  yr+1 and i_category='jewelry'
	group by d_moy
	order by count(*) desc
	fetch first 1 rows only;

	select  d_moy into month3
	from store_sales_history, item, date_dim
	where ss_item_sk = i_item_sk and ss_sold_date_sk=d_date_sk and d_year =  yr+2 and i_category='jewelry'
	group by d_moy
	order by count(*) desc
	fetch first 1 rows only;

	open c1 for 
	select  month1  ,  month2  ,  month3 
    into yr1, yr2, yr3 from dual;
    
    dbms_sql.return_result(c1);
end; 
