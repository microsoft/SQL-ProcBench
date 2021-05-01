create  or replace function returnReason_highEducated()
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select r_reason_desc, count(*) as cnt
	from store_returns_history, customer_demographics, reason
	where sr_customer_sk = cd_demo_sk and sr_reason_sk = r_reason_sk and cd_education_status = 'Advanced Degree'
	group by r_reason_desc
	order by cnt desc;
	
	return c1;
end; $$
language plpgsql

select returnReason_highEducated();
fetch all from mycursor;