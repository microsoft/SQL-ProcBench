--Total loss incurred on each channel by credit risky, hihgly educated men with non-zero dependents

create or alter procedure lossByEducated_risky
as
begin
	declare @web_loss decimal(15,2);
	declare @cat_loss decimal(15,2);
	declare @total_loss decimal(15,2);

	select @web_loss =  sum(ws_net_profit) 
	from web_sales_history
	where ws_bill_cdemo_sk in
	(select cd_demo_sk from customer_demographics where cd_gender='M' and cd_education_status = 'Advanced Degree' 
									and cd_dep_count>0 and  cd_credit_rating = 'High Risk')
	and ws_net_profit<0;

	select @cat_loss =  sum(cs_net_profit) 
	from catalog_sales_history
	where cs_bill_cdemo_sk in
	(select cd_demo_sk from customer_demographics where cd_gender='M' and cd_education_status = 'Advanced Degree' 
									and cd_dep_count>0 and  cd_credit_rating = 'High Risk')
	and cs_net_profit<0;

	select @total_loss =  @web_loss + @cat_loss;
	print(@total_loss);
end