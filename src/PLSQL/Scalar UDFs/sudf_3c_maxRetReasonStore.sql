create or replace function maxReturnReasonStore
return char 
is
    reason_desc char(100);
    reason_id char(16);
begin
	
	select dt1.r_reason_id, dt1.r_reason_desc
    into reason_id, reason_desc
	from
		(select r_reason_id, r_reason_desc, count(*) as cnt
		from store_returns_history, reason
		where sr_reason_sk = r_reason_sk
		group by r_reason_id, r_reason_desc) dt1
	where dt1.cnt = (select max(cnt) 
					 from (select r_reason_id, r_reason_desc, count(*) as cnt
						from store_returns_history, reason
						where sr_reason_sk = r_reason_sk
						group by r_reason_id, r_reason_desc)dt2
					 );
	return reason_desc;
end;

select maxReturnReasonStore as ans from DUAL;
