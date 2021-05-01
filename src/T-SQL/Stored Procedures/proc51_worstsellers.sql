create or alter procedure defectiveItemSellers
as
begin
	set nocount on;
	declare @sellerTable table (manufact int , cnt int);
	declare @manu int, @cnt int;

	declare c1 cursor for  
		select i_manufact_id,  count(*) cnt
		from web_returns, item, reason
		where wr_item_sk = i_item_sk and wr_reason_sk = r_reason_sk and
				wr_reason_sk is not NULL and wr_item_sk is not NULL and
				i_manufact_id is not NULL and
				(r_reason_desc = 'Parts missing' or r_reason_desc = 'Not working any more' or r_reason_desc = 'reason 38')
		group by i_manufact_id;
	
	open c1;
	fetch next from c1 into @manu, @cnt;
	while(@@FETCH_STATUS=0)
	begin
		if(@cnt>=20)
			insert into @sellerTable values (@manu, @cnt);
		fetch next from c1 into @manu, @cnt;
	end
	close c1;
	deallocate c1;
	select * from @sellerTable;
end