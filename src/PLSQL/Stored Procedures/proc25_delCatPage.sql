create or replace procedure deleteCatalogPage( delContent varchar2,  updateContent varchar2,  updateDept varchar2)
is
begin
	if( delContent!='') then
		delete from catalog_page where cp_description like '%' || delContent || '%';
	end if;

	if( updateContent!='') then
		update catalog_page set cp_department =  updateDept where cp_description like '%' || updateDept || '%';
	end if;
end;

--execution query
call deleteCatalogPage ('weapon', 'patient', 'Medical')

