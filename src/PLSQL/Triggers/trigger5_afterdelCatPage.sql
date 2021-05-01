CREATE or REPLACE TRIGGER deleteCatPage 
AFTER DELETE  
ON catalog_page
FOR EACH ROW
begin
		if(:old.cp_type='monthly ') then
			raise_application_error(-20100, 'cannot delete page from monthly catalog as per policy');
		else 
			DELETE from catalog_sales where cs_catalog_page_sk = :old.cp_catalog_page_sk;
			DELETE from catalog_returns where cr_catalog_page_sk = :old.cp_catalog_page_sk;
		end if;
end;

--invocation query
delete from catalog_page where cp_description like '%weapon%';