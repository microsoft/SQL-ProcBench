create or alter procedure getStoreByManager(@manager varchar(40))
as
begin
	if not exists (select * from store where s_manager= @manager)
	begin
		RAISERROR('No stores operated by this manager', 10, 16);
	end
	else
		select s_street_number, s_street_name, s_street_type, s_suite_number, s_city, s_county, s_state,s_zip, s_country 
		from store
		where s_manager = @manager;
end
