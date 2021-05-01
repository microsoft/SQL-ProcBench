--how may people shopped from a web_page
create or replace function popularWebPages()
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select ws_web_page_sk,count(*) as cnt from web_sales_history, web_page
	where ws_web_page_sk = wp_web_page_sk
	group by ws_web_page_sk
	order by cnt desc
	limit 100;
	
	return c1;
end; $$
language plpgsql


select popularWebPages();
fetch all from mycursor;