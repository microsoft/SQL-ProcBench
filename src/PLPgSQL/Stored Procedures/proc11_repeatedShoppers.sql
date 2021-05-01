--people who shopped in 5 diffrent months in a given year from store

create  or replace function repeatedShoppers (yr int)
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select ss_customer_sk, count(*)
	from
	(select distinct ss_customer_sk, d_moy
	from store_sales_history, date_dim
	where ss_sold_date_sk = d_date_sk
		and d_year = yr
		and ss_customer_sk is not NULL
	)t
	group by ss_customer_sk
	having count(*)>=5
	order by count(*) desc;	
	
	return c1;
end; $$
language plpgsql

select repeatedShoppers(1998);
fetch all from mycursor;
