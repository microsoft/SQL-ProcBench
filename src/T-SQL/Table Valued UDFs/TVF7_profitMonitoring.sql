--analyse the profit of a store for a given duration.
create or alter function profitMonitoring(@startDate date, @endDate date, @givenStore int)
returns @profitTable table(dt date, profit decimal(15, 2))
as
begin
	if(@startDate>@endDate)
		return;
	declare @dateSk int;
	declare @dayProfit decimal (15, 2);
	while(@startDate<=@endDate)
	begin
		set @dateSk = (select d_date_sk from date_dim where d_date = @startDate)
		set @dayProfit = (select sum(ss_net_profit) 
						from store_sales_history
						where ss_sold_date_sk=@dateSk and ss_store_sk = @givenStore);
		
		insert into @profitTable values (@startDate, @dayProfit);
		set @startDate = DATEADD(dy, 1, @startDate);
	end
	return;
end
go