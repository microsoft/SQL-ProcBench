create or replace procedure returnReason_lessEducated
AS  c1 sys_refcursor; 
BEGIN

    open c1 for 

	select r_reason_desc, count(*) as cnt
	from store_returns_history, customer_demographics, reason
	where sr_customer_sk = cd_demo_sk and sr_reason_sk = r_reason_sk and cd_education_status = 'Primary'
	group by r_reason_desc
	order by cnt desc;
    
     dbms_sql.return_result(c1);
end; 