CREATE or replace function lowIncomeCustomerWithHighPurchaseAmount(amount decimal(7, 2))
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select distinct ss_customer_sk, ib_income_band_sk 
	from store_sales_history, household_demographics, income_band
	where ss_hdemo_sk = hd_demo_sk
		and hd_income_band_sk = ib_income_band_sk
		and ss_net_paid_inc_tax>amount
		and ib_income_band_sk<=4;
	return c1;
END; $$
language plpgsql

select lowIncomeCustomerWithHighPurchaseAmount(1000);
fetch all from mycursor;
