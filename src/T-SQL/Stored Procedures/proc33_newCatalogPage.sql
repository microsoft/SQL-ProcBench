create or alter procedure newCatalogPage(@strtDate int, @endDate int, @dept varchar(50), @catNumber int, 
										@pgNum int, @desc varchar(100), @typevarchar varchar(100))
as
begin
	set nocount on;

	declare @randomString char(16);
	declare @sk int;
	declare @id char(16);
	
	set @sk = (select max(cp_catalog_page_sk)+1 from catalog_page);
	
	EXEC dbo.CreateRandomString @randomString OUTPUT;
	set @id = @randomString;
	insert into  catalog_page (cp_catalog_page_sk, cp_catalog_page_id, cp_start_date_sk, cp_end_date_sk,
								cp_department, cp_catalog_number, cp_catalog_page_number, cp_description, cp_type)
			values (@sk, @id, @strtDate, @endDate, @dept, @catNumber, @pgNum, @desc, @typevarchar);
end