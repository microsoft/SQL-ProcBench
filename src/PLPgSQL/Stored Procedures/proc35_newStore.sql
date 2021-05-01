create procedure newStore( store_sk int,  manager varchar(40))
language plpgsql
as $$
begin
	if not exists (select * from store where s_store_sk= store_sk) then
		insert into store (s_store_sk, s_store_id, s_manager) values ( store_sk, DEFAULT,  manager);
	else
		update store set s_manager  =  manager where s_store_sk =  store_sk;
	end if;
end; $$