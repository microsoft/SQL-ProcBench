create or replace function lossByEducated_risky()
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
	web_loss decimal(15,2);
	cat_loss decimal(15,2);
	total_loss decimal(15,2);
begin
	select sum(ws_net_profit)  into web_loss
	from web_sales_history
	where ws_bill_cdemo_sk in
	(select cd_demo_sk from customer_demographics where cd_gender='M' and cd_education_status = 'Advanced Degree' 
									and cd_dep_count>0 and  cd_credit_rating = 'High Risk')
	and ws_net_profit<0;

	select  sum(cs_net_profit) into cat_loss
	from catalog_sales_history
	where cs_bill_cdemo_sk in
	(select cd_demo_sk from customer_demographics where cd_gender='M' and cd_education_status = 'Advanced Degree' 
									and cd_dep_count>0 and  cd_credit_rating = 'High Risk')
	and cs_net_profit<0;

	open c1 for 
	select web_loss + cat_loss into total_loss;
	
	return c1;
end; $$
language plpgsql