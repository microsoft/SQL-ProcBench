--how may people shopped from a web_page
create procedure popularWebPages
as
begin
	set nocount on;

	select top 100 ws_web_page_sk,count(*) as cnt from web_sales_history, web_page
	where ws_web_page_sk = wp_web_page_sk
	group by ws_web_page_sk
	order by cnt desc
end
go