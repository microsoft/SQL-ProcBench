--analyse the profit of a store for a given duration.
CREATE or REPLACE TYPE profit_o IS object(
   dt date, profit decimal(15, 2)
);
/

Create or REPLACE type profit_t is TABLE OF profit_o;


create or replace function profitMonitoring(startDate date, endDate date, givenStore int)
return profit_t
is
    profitTable profit_t;
    dateSk int;
    newdate date;
    dayProfit decimal(15, 2);
begin
	if(startDate>endDate) then
		return profitTable;
    end if;
    newDate:=startDate;
	while(newDate<=endDate)
    loop
		select d_date_sk into dateSk from date_dim where d_date = startDate;
        
		select sum(ss_net_profit) into dayprofit
        from store_sales_history
        where ss_sold_date_sk=dateSk and ss_store_sk = givenStore;
            
        profitTable.extend;
        profitTable(profitTable.last) := profit_o(startDate, dayProfit);
		newDate:=startDate+1;
	end loop;
	return profitTable;
end;
