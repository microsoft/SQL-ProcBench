create or replace procedure deleteCatalogPage( delContent varchar(20),  updateContent varchar(20),  updateDept varchar(40))
language plpgsql
as $$
begin
	if( delContent!='') then
		delete from catalog_page where cp_description like '%' || delContent || '%';
	end if;

	if( updateContent!='') then
		update catalog_page set cp_department =  updateDept where cp_description like '%' || updateDept || '%';
	end if;
end; $$

--execution query
call deleteCatalogPage ('weapon', 'patient', 'Medical')
go
