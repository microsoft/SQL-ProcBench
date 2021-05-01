create or replace procedure getStoreByManager(manager varchar2)
as 
c1 sys_refcursor; 
cnt int;
begin
    select count(*) into cnt from store where s_manager= manager;
	if (cnt=0) then
		raise_application_error (-20111, 'No stores operated by this manager');

	else
        open c1 for 
		select s_street_number, s_street_name, s_street_type, s_suite_number, s_city, s_county, s_state,s_zip, s_country 
		from store
		where s_manager = manager;
        
        dbms_sql.return_result(c1);
	end if;
end; 