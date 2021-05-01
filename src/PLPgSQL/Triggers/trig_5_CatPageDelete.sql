create or replace function deleteCatPageTriggerFunc()
returns trigger as
$$
begin
	if(old.cp_type='monthly ') then
			raise exception 'cannot delete page from monthly catalog as per policy';
		else 
			DELETE from catalog_sales where cs_catalog_page_sk = old.cp_catalog_page_sk;
			DELETE from catalog_returns where cr_catalog_page_sk = old.cp_catalog_page_sk;
		end if;	
	return new;
end;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER deleteCatPage 
AFTER DELETE  
ON catalog_page
FOR EACH ROW
	execute procedure deleteCatPageTriggerFunc();	

--invocation query
delete from catalog_page where cp_description like '%weapon%';