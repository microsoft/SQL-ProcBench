create or alter procedure setPreferredCustomers
as
begin
	declare @currentPref char(1);
	declare @cust int;

	create table #prefCust (cust_sk int);

	INSERT INTO #prefCust EXEC dbo.repeatedShoppers;

	declare c1 cursor static for (select cust_sk from #prefCust);
	open c1;
	fetch next from c1 into @cust;
	while(@@FETCH_STATUS=0)
	begin
		set @currentPref = (select c_preferred_cust_flag from customer where c_customer_sk=@cust);
		if(@currentPref='N')
		begin
			update customer set c_preferred_cust_flag='Y' where c_customer_sk=@cust;
		end
		fetch next from c1 into @cust;
	end
	close c1;
	deallocate c1;
end