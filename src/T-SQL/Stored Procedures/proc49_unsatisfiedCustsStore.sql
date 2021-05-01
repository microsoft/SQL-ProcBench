--customers who after returning an order did not shop for atleast 6 months through the same channel(store).

create or alter procedure unsatisfiedCustomersStore
as
begin
	declare @cust int;
	declare @retDate date, @minDate date;
	declare @custTable table (custSk int);
	declare c1 cursor static for 
	(select sr_customer_sk, d_date from store_returns, date_dim 
	where d_date_sk = sr_returned_date_sk and sr_customer_sk is not NULL);
	open c1;
	fetch next from c1 into @cust, @retDate;
	while(@@FETCH_STATUS=0)
	begin
		set @minDate = (select min(d_date) from store_sales, date_dim 
						where ss_sold_date_sk=d_date_sk and ss_customer_sk=@cust
								and d_date>@retDate);
		if(DATEDIFF(MONTH, @retDate, @minDate)>=6)
		begin
			insert into @custTable values (@cust);
		end
		fetch next from c1 into @cust, @retDate;
	end
	close c1;
	deallocate c1;
	select * from @custTable;
end