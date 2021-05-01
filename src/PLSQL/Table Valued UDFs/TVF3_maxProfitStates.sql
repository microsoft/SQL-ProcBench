--Compute store sales net profit ranking by state and city for a given year 
--and determine the five most profitable states. 
CREATE or REPLACE TYPE profitRank_o IS object(
   state char(2), city varchar(60), profit decimal(15, 2)
);
/

Create or REPLACE type profitRank_t is TABLE OF profitRank_o;


Create or replace Function maxProfitStates(givenYear int)
RETURN profitRank_t
is
    profitTable profitRank_t;
begin
        select profitRank_o(t.s_state, t.s_city, t.totalProfit)
        bulk collect into profitTable
        from
            (select s_state, s_city, sum(ss_net_profit) as totalProfit
            from store_sales, store, date_dim
            where ss_store_sk = s_store_sk
                and ss_sold_date_sk = d_date_sk
                and d_year = givenYear
            group by s_state, s_city
            order by totalProfit desc)t
        where rownum<=5
        ;

	return profitTable;
end;


