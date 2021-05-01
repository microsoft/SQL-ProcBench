create  or replace function getImmigrantCustomers()
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select c_customer_sk, c_birth_country, ca_state as currentState, cd_gender, cd_marital_status, 
		cd_education_status, ib_lower_bound, ib_upper_bound,
		cd_credit_rating, cd_dep_count
	from customer, customer_address, household_demographics, income_band, customer_demographics
	where c_current_addr_sk = ca_address_sk
		and c_birth_country != ca_country
		and c_current_hdemo_sk=hd_demo_sk
		and hd_income_band_sk = ib_income_band_sk
		and cd_demo_sk = c_current_cdemo_sk
		and c_customer_sk is not NULL;
	return c1;
end; $$
language plpgsql

select getImmigrantCustomers();
fetch all from mycursor;