--cusotmers belonging to a low income band and who made purchases of more than a given amount. 

CREATE PROCEDURE lowIncomeCustomerWithHighPurchaseAmount(@amount decimal(7, 2))
AS
BEGIN
	set nocount on;

	select distinct ss_customer_sk, ib_income_band_sk 
	from store_sales_history, household_demographics, income_band
	where ss_hdemo_sk = hd_demo_sk
		and hd_income_band_sk = ib_income_band_sk
		and ss_net_paid_inc_tax>@amount
		and ib_income_band_sk<=4
END