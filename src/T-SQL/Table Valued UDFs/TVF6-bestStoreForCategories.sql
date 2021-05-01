--top stores for each category based on the number of items sold
create or alter function bestStoreForCatgory()
returns @relation table (category char(50), store int)
as
begin
	declare @cat char(50);
	declare @maxStore int;
	declare c1 cursor for (select distinct i_category from item where i_category is not null)
	open c1;
	fetch next from c1 into @cat;
	while(@@FETCH_STATUS=0)
	begin
		set @maxStore = (select ss_store_sk from (
									select top 1 ss_store_sk, count(*) as cnt
									from store_sales, item
									where ss_item_sk = i_item_sk and i_category = @cat and ss_store_sk is not NULL
									group by ss_store_sk
									order by cnt desc)t);
		insert into @relation values (@cat, @maxStore);
		fetch next from c1 into @cat;
	end
	return;
end
go