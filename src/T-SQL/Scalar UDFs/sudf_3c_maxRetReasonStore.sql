--Most frequent reason for returns through stores

create or alter function maxReturnReasonStore()
returns char(100) as
begin
	
	declare @r_reason_desc char(100), @reason_id char(16);
	select @reason_id  = r_reason_id, @r_reason_desc = r_reason_desc
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
					 )
	return @r_reason_desc;
end
go