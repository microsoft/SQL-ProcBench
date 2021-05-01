CREATE OR ALTER TRIGGER ca_update ON customer_address
AFTER UPDATE
AS  
	if(update(ca_address_sk))
	begin
		RAISERROR('Illegal update operation', 10, 1);
		ROLLBACK TRANSACTION;
	end
	
	else
	begin
		declare @adr_sk int;
		declare @adr_sk_varchar varchar(max);
		declare @insCity varchar(60), @delCity varchar(60), @insState char(2), @delState char(2), @insCount varchar(30), @delCount varchar(30);
		declare c1 cursor for select ca_address_sk, ca_city, ca_state, ca_country from inserted;
		open c1;
		fetch next from c1 into @adr_sk, @insCity, @insState, @insCount;
		while(@@FETCH_STATUS=0)
		begin
			select @delCity = ca_city, @delState=ca_state, @delCount = ca_country from deleted d where d.ca_address_sk = @adr_sk;
			set @adr_sk_varchar = CAST(@adr_sk AS varchar(max));
			if(@delCount!=@insCount)
				insert into logTable values ('address' + @adr_sk_varchar + 'changed to different country', GETDATE());
			else if (@delState!=@insState)
				insert into logTable values ('address' + @adr_sk_varchar + 'changed to different state', GETDATE());
			else if (@delCity!=@insCity)
				insert into logTable values ('address' + @adr_sk_varchar + 'changed to different city', GETDATE());
			fetch next from c1 into @adr_sk, @insCity, @insState, @insCount ;
		end
		close c1;
		deallocate c1;
	end
GO 

--invocation Query
update customer_address  
set ca_country=
(case 
when (ca_address_sk<=5) then 'India'
when (ca_address_sk>5 and ca_address_sk<=10) then 'NewZealand'
when (ca_address_sk>10 and ca_address_sk<=15) then 'France'
end
) 
where ca_address_sk<=15;