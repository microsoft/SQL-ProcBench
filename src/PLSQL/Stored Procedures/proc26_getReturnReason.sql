--does look rather weird. Change logic.
create procedure getReturnReason
	@reason_sk	int, 
	@reason_id	nvarchar(16) 
as
begin
	set nocount on 	
	
	if(@reason_sk = null and @reason_id = null)
	begin
		raiserror('Invalid arguments', 16, 1)
	end
	
	declare @curDate date = GetDate();
	declare @day int  = DAY(@curDate);
	declare @month int  = MONTH(@curDate);
	declare @year int  = YEAR(@curDate);

	select cr_reason_sk, r_reason_desc
	from catalog_returns, date_dim, reason
	where cr_returned_date_sk = d_date_sk
		and r_reason_sk = cr_reason_sk
		and d_moy <= @month  and d_moy >= @month-5;
end

select * from reason
