--information on customers who purchased items from catalog that were on sale during a particular time
CREATE or replace function saleShoppers()
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select  cs_bill_customer_sk as customer_sk, 
			c_first_name, c_last_name, c_email_address, c_birth_year, 
			cs_item_sk, d1.d_date as sold_date,  
			d2.d_date as promo_strt_date, d3.d_date as promo_end_date, 
			cs_promo_sk
	from catalog_sales_history, promotion, date_dim d1, date_dim d2, date_dim d3, customer
	where p_promo_sk = cs_promo_sk
		and cs_sold_date_sk = d1.d_date_sk
		and p_start_date_sk = d2.d_date_sk
		and p_end_date_sk = d3.d_date_sk 
		and d1.d_date>=d2.d_date 
		and d1.d_date<=d3.d_date
		and cs_bill_customer_sk = c_customer_sk;
		
	return c1;

END; $$
language plpgsql