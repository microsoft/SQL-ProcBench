--Out of the 1000 most returned items across all the sales channel, find the ones that are outdated.

create or alter function MaxReturnItems()
returns @maxretItems table (itemNo int, manufactId int)
as
begin
	declare @itemNo int, @manufact int;
	declare @recDate  date;
	declare @itemTbl table (itemNo int, cnt int);

	insert into @itemTbl
		select top 1000 cr_item_sk, count(cnt) totalCnt
		from
			(select cr_item_sk, count(*) cnt from catalog_returns group by cr_item_sk
			union all 
			select wr_item_sk, count(*) cnt from web_returns group by wr_item_sk
			union all
			select sr_item_sk, count(*) cnt from store_returns group by sr_item_sk)t
		group by cr_item_sk
		order by totalCnt desc

	declare c1 cursor for select itemNo from @itemTbl;
	open c1;
	fetch next from c1 into @itemNo;
	while(@@FETCH_STATUS=0)
	begin
		set @recDate = (select i_rec_start_date from item where i_item_sk = @itemNo);
		set @manufact = (select i_manufact_id from item where i_item_sk = @itemNo);
		if(DATEDIFF(day, @recDate, '2000-01-01')>0)
			insert into @maxretItems values (@itemNo, @manufact);	
		fetch next from c1 into @itemNo;
	end
	close c1;
	deallocate c1;
	return;
end
go