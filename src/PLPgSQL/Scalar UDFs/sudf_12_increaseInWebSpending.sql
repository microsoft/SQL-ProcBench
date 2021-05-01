--Of the customers who purchased from web in both years 2000 and 2001, find positive increase in spending from one year to the other.

create or replace function increaseInWebSpending(cust_sk int)
returns decimal
language plpgsql
as
$$
declare
    spending1  decimal;
	spending2  decimal;
	increase  decimal;
begin
	spending1:=0;
    spending2:=0;
    increase:=0;
    
	select sum(ws_net_paid_inc_ship_tax) into spending1 
    from web_sales_history, date_dim
    where d_date_sk = ws_sold_date_sk
        and d_year = 2001
        and ws_bill_customer_sk=cust_sk;
        
	select sum(ws_net_paid_inc_ship_tax)  into spending2
    from web_sales_history, date_dim
    where d_date_sk = ws_sold_date_sk
        and d_year = 2000
        and ws_bill_customer_sk=cust_sk;
        
	if(spending1<spending2) then
		return -1;
	else
		increase := spending1-spending2;
    end if;
	return increase;

end;
$$;


select c_customer_sk, increaseInWebSpending(c_customer_sk) 
from customer
where c_customer_sk in 
	(select ws_bill_customer_sk
	from web_sales_history, date_dim
	where d_date_sk = ws_sold_date_sk
		and d_year = 2000

	INTERSECT

	select ws_bill_customer_sk
	from web_sales_history, date_dim
	where d_date_sk = ws_sold_date_sk
		and d_year = 2001
	)
	and increaseInWebSpending(c_customer_sk) > 0;