--how may people shopped from a web_page
create or replace procedure popularWebPages
as
     c1 sys_refcursor;
begin
    open c1 for 
	select ws_web_page_sk,count(*) as cnt from web_sales_history, web_page
	where ws_web_page_sk = wp_web_page_sk
	group by ws_web_page_sk
	order by cnt desc
	fetch first 100 rows only;
    
    dbms_sql.return_result(c1);
end; 