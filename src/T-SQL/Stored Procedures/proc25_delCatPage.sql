create or alter procedure deleteCatalogPage(@delContent varchar(20), @updateContent varchar(20), @updateDept varchar(40))
as
begin
	if(@delContent!='')
	begin
		select cp_catalog_number as deletedCat, cp_catalog_page_number as deletedPgNum
		from catalog_page
		where cp_description like '%'+@delContent+'%';

		delete from catalog_page where cp_description like '%'+@delContent+'%';
	end

	if(@updateContent!='')
		update catalog_page set cp_department = @updateDept where cp_description like '%'+@updateDept+'%';
end
go

--execution query
exec dbo.deleteCatalogPage 'weapon', 'patient', 'Medical'
go