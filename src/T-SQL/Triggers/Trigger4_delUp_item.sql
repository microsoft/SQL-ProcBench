CREATE or ALTER TRIGGER delUp_item ON item
AFTER DELETE, UPDATE
AS  
	if(update(i_item_sk)) 
	begin
		raiserror('Operation not allowed', 16, 10);
		rollback transaction;
	end

	if exists (select * from inserted)  --this means updates to item table happened
	begin
		insert into logTable values ('logging updation to item table', GETDATE());
		return;
	end

	--Triggered due to a deletion in the item table.
	else
	begin
		delete from catalog_sales 
		where cs_item_sk in (select i_item_sk from deleted);
	
		delete from catalog_returns
		where cr_item_sk in (select i_item_sk from deleted);

		delete from store_sales 
		where ss_item_sk in (select i_item_sk from deleted);

		delete from store_returns
		where sr_item_sk in (select i_item_sk from deleted);

		delete from web_sales 
		where ws_item_sk in (select i_item_sk from deleted);
		delete from web_returns

		where wr_item_sk in (select i_item_sk from deleted);

		delete from promotion
		where p_item_sk in (select i_item_sk from deleted);
	
		delete from inventory
		where inv_item_sk in (select i_item_sk from deleted);
	end
	
GO 

--invocation query
declare @item int;
declare c1 cursor for select * from #itemTable;
open c1;
fetch next from c1 into @item;
while(@@FETCH_STATUS=0)
begin
	delete from item where i_item_sk = @item;
	fetch next from c1 into @item;
end
close c1;
deallocate c1;


create table #itemTable (itemSk int)

insert into #itemTable 
select cs_item_sk from catalog_sales where cs_item_sk<30000
intersect 
select ss_item_sk from  store_sales where ss_item_sk<30000 and ss_item_sk>=20000
intersect 
select ws_item_sk from  web_sales where ws_item_sk<30000 and ws_item_sk>=20000
intersect 
select cr_item_sk from  catalog_returns where cr_item_sk<30000 and cr_item_sk>=20000
intersect 
select sr_item_sk from  store_returns where sr_item_sk<30000 and sr_item_sk>=20000
intersect 
select wr_item_sk from  web_returns where wr_item_sk<30000 and wr_item_sk>=20000
intersect 
select inv_item_sk from inventory where inv_item_sk<30000 and inv_item_sk>=20000
intersect 
select p_item_sk from  promotion where p_item_sk<30000 and p_item_sk>=20000;