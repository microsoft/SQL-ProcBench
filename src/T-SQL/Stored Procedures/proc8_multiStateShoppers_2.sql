--Customers who have shopped in stores from more than 1 state in a given year and month
create or alter procedure multiStateShoppers  (@year int, @moy int)
as
begin
	declare @custTable Table (cust int, cnt int);

	insert into @custTable 
	select ss_customer_sk, count(*) from
	(select distinct ss_customer_sk, s_state
	from store_sales_history, date_dim, store
	where ss_sold_date_sk = d_date_sk and ss_store_sk = s_store_sk
		and d_year = @year and d_moy =@moy and ss_customer_sk is not NULL and ss_store_sk is not NULL
	)t
	group by ss_customer_sk
	order by ss_customer_sk;

	select * from @custTable where cnt>1 order by cust;
end
