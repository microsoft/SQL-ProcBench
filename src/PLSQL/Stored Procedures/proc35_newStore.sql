create procedure newStore( store_sk int,  mgr varchar)
is
    cnt int;
begin
    select count(*) into cnt from store where s_store_sk= store_sk;
	if (cnt=0) then
		insert into store (s_store_sk, s_store_id, s_manager) values ( store_sk, DEFAULT,  mgr);
	else
		update store set s_manager  =  mgr where s_store_sk =  store_sk;
	end if;
end; 