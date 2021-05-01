--check if multiple large stores(>250 employees) are managed by the same person.

create or alter function sameManagerForLargeStores()
returns bit 
as
begin
	declare @manag varchar(40);
	declare @allManag nvarchar(max);
	set @allManag='';
	declare c1 cursor static for 
		(select s_manager from store where s_number_employees>250);
	open c1;
	fetch next from c1 into @manag;
	while(@@FETCH_STATUS=0)
	begin
		set @allManag=@allManag+@manag+', ';
		fetch next from c1 into @manag;	
	end
	close c1;
	deallocate c1;
	return 1-dbo.isListDistinct(@allManag, ',');
end
go