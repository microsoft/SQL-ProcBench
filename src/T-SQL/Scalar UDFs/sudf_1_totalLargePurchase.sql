--Report the total catalog sales for customers from a given state who made purchases of 
-- more than a given amount in a given year and quarter.

create or alter function totalLargePurchases(@givenState char (2), @amount decimal(7, 2), @yr int, @qtr int)
returns decimal(15, 2)
as
begin
	return
		(select sum(cs_net_paid_inc_ship_tax)
		from catalog_sales_history, customer, customer_address, date_dim
		where cs_bill_customer_sk = c_customer_sk and
			  c_current_addr_sk = ca_address_sk and
			  d_date_sk = cs_sold_date_sk and
			  ca_state = @givenState and
			  cs_net_paid_inc_ship_tax >= @amount and 
			  d_year = @yr and d_qoy = @qtr
	     )
end
go


--invocation query
select ca_state, d_year, d_qoy,  dbo.totalLargePurchases(ca_state, 1000, d_year, d_qoy)
from customer_address, date_dim
where d_year in (1998, 1999, 2000) and ca_state is not NULL
group by ca_state, d_year, d_qoy
order by ca_state, d_year, d_qoy;