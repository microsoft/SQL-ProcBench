CREATE or ALTER TRIGGER deleteCatPage ON catalog_page
AFTER DELETE  
AS  
	declare @catalog_page int;
	declare @type varchar(100); 
	declare c1 cursor static for (select cp_catalog_page_sk, cp_type from DELETED);
	open c1;
	fetch next from c1 into @catalog_page, @type;
	while(@@fetch_status=0)
	begin
		if(@type='monthly ')
		begin
			raiserror('cannot delete page from monthly catalog as per policy', 10, 1);
			rollback transaction;
		end
		else
		begin
			DELETE from catalog_sales where cs_catalog_page_sk = @catalog_page;
			DELETE from catalog_returns where cr_catalog_page_sk = @catalog_page;
		end
		fetch next from c1 into @catalog_page, @type;
	end
	close c1;
	deallocate c1;
GO 

--invocation query
delete from catalog_page where cp_description like '%weapon%';