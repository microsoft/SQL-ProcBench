--Were the stores run by the given manager profitable in the given year?

create or alter function profitableManager(@manager varchar(40), @year int)
returns int as
begin
	declare @netProfit decimal(15,2);
	set @netProfit = (select sum(ss_net_profit)  
						from store, store_sales_history, date_dim
						where ss_sold_date_sk = d_date_sk
							and d_year=@year 
							and s_manager = @manager
							and s_store_sk = ss_store_sk);
	if(@netProfit>0)
		return 1;
	return 0;
end
go

--invocation query
select s_manager from store where dbo.profitableManager(s_manager, 2001)<=0;
go