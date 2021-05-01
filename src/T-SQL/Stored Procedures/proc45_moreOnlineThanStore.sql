-- Customers who spend more money online than in stores

create or alter procedure moreOnlineThanStore
as
begin
	declare @preferredChannel varchar(50);
	declare @cust int;
	declare c1 cursor static for (select c_customer_sk from customer);
	open c1;
	fetch next from c1 into @cust;
	while(@@FETCH_STATUS=0)
	begin
		set @preferredChannel = (select dbo.preferredChannel_wrtExpenditure(@cust));
		if(@preferredChannel='catalog' or @preferredChannel='web')
			print(@cust);
		fetch next from c1 into @cust;
	end
	close c1;
	deallocate c1;
end

