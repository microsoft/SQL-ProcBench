--For catalog items sold in a given month of a year that have deficient stock in inventory,
--find out how many of these were also ordered in large amounts through the web channel.

create or alter function highDeficiencyAmount(@month int)
returns int
as 
begin
	declare @catalogDeficitItems table (item int, deficiency int);
	declare @webItemTable table (item int, qty int, defType varchar(40));
	declare @item int, @amt int, @availableQty int, @catDefItem int, @highDemandCount int, @web_qty int;

	declare c1 cursor static forward_only for 
	(select cs_item_sk, sum(cs_quantity) as ordered_amt
	from catalog_sales, date_dim
	where d_date_sk = cs_sold_date_sk
		and d_moy = @month
	group by cs_item_sk);

	open c1; 
	fetch next from c1 into @item, @amt;
	
	while(@@fetch_status=0)
	begin
		select @availableQty = sum(inv_quantity_on_hand) from inventory, date_dim
		where inv_item_sk = @item
			and inv_date_sk = d_date_sk
			and d_moy =@month;
		
		if(@availableQty<@amt)
		begin
			insert into @catalogDeficitItems values (@item, @amt-@availableQty);
		end
		fetch next from c1 into @item, @amt;
	end

	close c1;
	deallocate c1;

	declare c2 cursor static for (select item from @catalogDeficitItems);
	open c2;
	fetch next from c2 into @catDefItem;
	
	while(@@fetch_status=0)
	begin
		select @web_qty = sum(ws_quantity)
		from web_sales, date_dim
		where d_date_sk = ws_sold_date_sk
			and d_moy = @month
			and ws_item_sk = @catDefItem;

		if(@web_qty>0)	
		begin
			if(@web_qty<5)
				insert into @webItemTable values (@catDefItem, @web_qty, 'low deficiency');
			else if (@web_qty<10)
				insert into @webItemTable values (@catDefItem, @web_qty, 'medium deficiency');
			else	
				insert into @webItemTable values (@catDefItem, @web_qty, 'high deficiency');
		end
		fetch next from c2 into @catDefItem;
	end

	close c2;
	deallocate c2;

	set @highDemandCount = (select count(*) from @webItemTable where defType='high deficiency');
	return @highDemandCount;
end
go

--invocation Query
create table #monthTab(mnth int);
insert into #monthTab values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)
select * from #monthTab

select mnth, dbo.highDeficiencyAmount(mnth) from #monthTab
go