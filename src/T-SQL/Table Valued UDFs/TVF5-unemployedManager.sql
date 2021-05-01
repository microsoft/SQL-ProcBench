CREATE TYPE ManagerType 
   AS TABLE
      (man_name varchar(40) unique, numClosed int);
GO

CREATE or alter function unemployedManagers (@closedManagers ManagerType readonly)
RETURNS @unemployedMan table (manName varchar(40))
AS
BEGIN
	declare @manager varchar(40);
	declare c1 cursor for (select man_name from @closedManagers);
	open c1;
	fetch next from c1 into @manager;
	while(@@fetch_status=0)
	begin
		if not exists (select * from call_center where cc_manager = @manager)
		begin
			insert into @unemployedMan values (@manager);
		end
		fetch next from c1 into @manager;
	end
	return;
END
go

--given a list of call-center manager names, find which of these are currently unemployed. This is called from stored procedure proc_53_shutOldCC