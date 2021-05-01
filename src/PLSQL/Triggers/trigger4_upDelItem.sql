CREATE or replace TRIGGER delUp_item 
AFTER DELETE or UPDATE
ON item
FOR EACH ROW
BEGIN
	if(:new.i_item_sk is not NULL) then  --this means updates to item table happened
		insert into logTable values ('logging updation to item table', current_timestamp);
		return;
	end if;

	--Triggered due to a deletion in the item table.
	delete from catalog_sales where cs_item_sk = :old.i_item_sk;
	
	delete from catalog_returns where cr_item_sk  =:old.i_item_sk;

	delete from store_sales where ss_item_sk  =:old.i_item_sk;

	delete from store_returns where sr_item_sk= :old.i_item_sk;

	delete from web_sales where ws_item_sk = :old.i_item_sk;

	delete from web_returns where wr_item_sk = :old.i_item_sk;

	delete from promotion where p_item_sk = :old.i_item_sk;
	
	delete from inventory where inv_item_sk = :old.i_item_sk;	
END; 

--invocation query
declare vitem int;
cursor c1 is select itemSk from itemTable;
begin
    open c1;
    loop
        fetch c1 into vitem;
        exit when c1%NOTFOUND;
        delete from item where i_item_sk = vitem;
    end loop;
    close c1;
end;


create table itemTable (itemSk int)

insert into itemTable 
select cs_item_sk from catalog_sales where cs_item_sk<30000 and cs_item_sk>=20000;
intersect 
select ss_item_sk from  store_sales where ss_item_sk<30000 and ss_item_sk>=20000;
intersect 
select ws_item_sk from  web_sales where ws_item_sk<30000 and ws_item_sk>=20000;
intersect 
select cr_item_sk from  catalog_returns where cr_item_sk<30000 and cr_item_sk>=20000;
intersect 
select sr_item_sk from  store_returns where sr_item_sk<30000 and sr_item_sk>=20000;
intersect 
select wr_item_sk from  web_returns where wr_item_sk<30000 and wr_item_sk>=20000;
intersect 
select inv_item_sk from inventory where inv_item_sk<30000 and inv_item_sk>=20000;
intersect 
select p_item_sk from  promotion where p_item_sk<30000 and p_item_sk>=20000;