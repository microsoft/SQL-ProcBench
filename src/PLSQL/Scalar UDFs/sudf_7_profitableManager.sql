create or replace function profitableManager(manager varchar, year number)
return number is
netProfit number(15, 2);
begin
	select  sum(ss_net_profit) into netProfit 
    from store, store_sales_history, date_dim
    where ss_sold_date_sk = d_date_sk
        and d_year=year 
        and s_manager = manager
        and s_store_sk = ss_store_sk;
	if(netProfit>0) then
		return 1;
    end if;
	return 0;
end;


select s_manager from store where profitableManager(s_manager, 2001)<=0;


