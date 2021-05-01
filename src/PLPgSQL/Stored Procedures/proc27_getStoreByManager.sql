create or replace function getStoreByManager(manager varchar(40))
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	if not exists (select * from store where s_manager= manager) then
		raise exception 'No stores operated by this manager';

	else
		open c1 for 
		select s_street_number, s_street_name, s_street_type, s_suite_number, s_city, s_county, s_state,s_zip, s_country 
		from store
		where s_manager = manager;
	end if;
	
	return c1;
end; $$
language plpgsql