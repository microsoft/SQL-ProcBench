--people who shopped in 5 diffrent months in a given year from store

create  procedure repeatedShoppers (yr int)
AS  c1 sys_refcursor; 
BEGIN

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
    
    dbms_sql.return_result(c1);
end; 