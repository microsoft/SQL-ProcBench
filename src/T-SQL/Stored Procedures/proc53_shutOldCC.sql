CREATE or alter TYPE ManagerType 
   AS TABLE
      (man_name varchar(40) unique, numClosed int);
GO

CREATE PROCEDURE ShutOldCallCenterInCounty
    @county varchar(30)
AS
BEGIN 
	declare @closedManager ManagerType;
	declare @cc_sk int , @openDate int, @numEmpl int;
	declare @manager varchar(40)= '', @city varchar(60) = '', @year int, @numCl int;
	declare c1 cursor static for (select cc_call_center_sk, cc_open_date_sk, cc_employees, cc_manager, cc_city
									from call_center where cc_county=@county);
	open c1;
	fetch next from c1 into @cc_sk, @openDate, @numEmpl, @manager, @city
	while(@@fetch_status=0)
	begin
		set @year = (select d_year from date_dim where d_date_sk = @openDate);
		if(@year<=1998 and @numEmpl<400)
		begin
			if not exists (select * from @closedManager where man_name = @manager)
				insert into @closedManager values (@manager, 1);
			else
				begin
					set @numCl = (select numClosed from @closedManager where man_name = @manager);
					insert into @closedManager values (@manager, @numCl+1);
				end
			delete from call_center where cc_call_center_sk = @cc_sk;  --delete this old, small CC
		end
		fetch next from c1 into @cc_sk, @openDate, @numEmpl, @city;
	end
	declare @tableName varchar(50) = '@closedManager';
	select * from dbo.unemployedManagers(@closedManager);
END;
GO
