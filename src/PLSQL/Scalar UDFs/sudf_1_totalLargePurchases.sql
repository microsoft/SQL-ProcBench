
--Report the total catalog sales for customers in selected geographical regions or who made purchases of 
-- more than a given amount for a given year and quarter.

create or replace function totalLargePurchases(givenState char, amount number, yr number, qtr number )
return number
is
pragma udf;
largePurchase number;
begin 
		select sum(cs_net_paid_inc_ship_tax) into largePurchase
		from catalog_sales_history, customer, customer_address, date_dim
		where cs_bill_customer_sk = c_customer_sk and
			  c_current_addr_sk = ca_address_sk and
			  ca_state = givenState and
			  cs_net_paid_inc_ship_tax >= amount and
			  d_date_sk = cs_sold_date_sk and d_year = yr and d_qoy = qtr;
	     return largePurchase;
end;

select ca_state, d_year, d_qoy,  totalLargePurchases(ca_state, 1000, d_year, d_qoy)
from customer_address_old, date_dim
where d_year in (1998, 1999, 2000) and ca_state is not NULL
group by ca_state, d_year, d_qoy
order by ca_state, d_year, d_qoy;
