--Total of high(>1000) return amounts for return reasons pertaining to price issues for all three channels. (the the current non-history cycle)

create or alter function dbo.highReturnReasons()
returns @return_reason TABLE(channel char(1), reason nvarchar(max), totalAmount decimal(15, 2))
as
begin
	declare @reason_store nvarchar(max);
	declare @total_store decimal(15, 2);
	declare @reason_web nvarchar(max);
	declare @total_web decimal(15, 2);	
	declare @reason_catalog nvarchar(max);
	declare @total_catalog decimal(15, 2);
	
	declare @return_amt decimal(15, 2);
	declare @desc nvarchar(max);
	
	set @total_store = 0.0;
	set @reason_store='';
	set @total_catalog = 0.0;
	set @reason_catalog = '';
	set @total_web = 0.0;
	set @reason_web = '';

	declare c1 cursor static for (select sr_return_amt, r_reason_desc from store_returns, reason
	where sr_reason_sk = r_reason_sk  and sr_return_amt>1000.0)

	open c1;
	fetch next from c1 into @return_amt, @desc;
	while(@@fetch_status=0)
	begin
		if(@desc like '%price%')
		begin
			set @total_store+=@return_amt;
			set @reason_store+=@desc;
		end
		fetch next from c1 into @return_amt, @desc;
	end
	close c1;
	deallocate c1;
	insert into @return_reason values ('s', @reason_store, @total_store);

	declare c2 cursor static for (select wr_return_amt, r_reason_desc from web_returns, reason
	where wr_reason_sk = r_reason_sk  and wr_return_amt>1000.0)

	open c2;
	fetch next from c2 into @return_amt, @desc;
	while(@@fetch_status=0)
	begin
		if(@desc like '%price%')
		begin
			set @total_web+=@return_amt;
			set @reason_web+=@desc;
		end
		fetch next from c2 into @return_amt, @desc;
	end
	close c2;
	deallocate c2;
	insert into @return_reason values ('w', @reason_web, @total_web);

	declare c3 cursor static for (select cr_return_amount, r_reason_desc from catalog_returns, reason
	where cr_reason_sk = r_reason_sk  and cr_return_amount>1000.0)

	open c3;
	fetch next from c3 into @return_amt, @desc;
	while(@@fetch_status=0)
	begin
		if(@desc like '%price%')
		begin
			set @total_catalog+=@return_amt;
			set @reason_catalog+=@desc;
		end
		fetch next from c3 into @return_amt, @desc;
	end
	close c3;
	deallocate c3;

	insert into @return_reason values ('c', @reason_catalog, @total_catalog);
	return;
end
go


select channel, reason, totalAmount
from dbo.highReturnReasons()