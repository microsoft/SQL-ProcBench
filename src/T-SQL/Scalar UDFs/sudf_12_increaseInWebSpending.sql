-- Find out the increase in web spending by a given customer from year 2000 to 2001. 

create or alter function increaseInWebSpending(@cust_sk int)
returns decimal(15, 2)
as
begin
	declare @spending1  decimal(15, 2)=0;
	declare @spending2  decimal(15, 2)=0;
	declare @increase  decimal(15, 2)=0;
	set @spending1 = (select sum(ws_net_paid_inc_ship_tax) 
						from web_sales_history, date_dim
						where d_date_sk = ws_sold_date_sk
							and d_year = 2001
							and ws_bill_customer_sk=@cust_sk);
	set @spending2 = (select sum(ws_net_paid_inc_ship_tax) 
						from web_sales_history, date_dim
						where d_date_sk = ws_sold_date_sk
							and d_year = 2000
							and ws_bill_customer_sk=@cust_sk);
	if(@spending1<@spending2)
		return -1;
	else
		set @increase = @spending1-@spending2;
	return @increase;

end
go

--invocation query
select t.ws_bill_customer_sk
from 
	(select ws_bill_customer_sk
	from web_sales_history, date_dim
	where d_date_sk = ws_sold_date_sk
		and d_year = 2000 and d_moy=1 and ws_bill_customer_sk is not NULL

	INTERSECT

	select ws_bill_customer_sk
	from web_sales_history, date_dim
	where d_date_sk = ws_sold_date_sk
		and d_year = 2001 and d_moy=1  and ws_bill_customer_sk is not NULL
	)t
where dbo.increaseInWebSpending(t.ws_bill_customer_sk) > 0;
