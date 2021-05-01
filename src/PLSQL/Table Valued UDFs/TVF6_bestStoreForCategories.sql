CREATE or REPLACE TYPE cat_o IS object(
   category char(50), store int
);
/

Create or REPLACE type cat_t is TABLE OF cat_o;

--top stores for each category based on the number of items sold
create or replace function bestStoreForCatgory
return cat_t
is 
    catTable cat_t;
    cat char(50);
    maxStore int;
    cursor c1 is (select distinct i_category from item where i_category is not null);
begin
	open c1;
	loop
    fetch c1 into cat;
		select ss_store_sk into maxStore 
        from (
                select ss_store_sk, count(*) as cnt
                from store_sales, item
                where ss_item_sk = i_item_sk and i_category = cat and ss_store_sk is not NULL
                group by ss_store_sk
                order by cnt desc
                )
        where rownum<=1;
        
		catTable.extend;
        catTable(catTable.last) := cat_o(cat, maxStore);
	end loop;
    close c1;
	return catTable;
end;
