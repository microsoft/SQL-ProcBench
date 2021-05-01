--people who shopped in 5 diffrent months in a given year from store
--make it a function maybe

create or alter procedure repeatedShoppers (@year int)
as 
begin
	set nocount on;

	select ss_customer_sk, count(*)
	from
	(select distinct ss_customer_sk, d_moy
	from store_sales_history, date_dim
	where ss_sold_date_sk = d_date_sk
		and d_year = 2001
		and ss_customer_sk is not NULL
	)t
	group by ss_customer_sk
	having count(*)>=5
	order by count(*) desc
	
end
go
