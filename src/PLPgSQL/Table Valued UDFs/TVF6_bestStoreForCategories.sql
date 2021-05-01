--top stores for each category based on the number of items sold

CREATE TYPE bestStoreForCatgoryRet AS (category char(50), store int);

CREATE OR REPLACE FUNCTION bestStoreForCatgory()
RETURNS SETOF bestStoreForCatgoryRet AS
$$
DECLARE
  cat char(50);
  maxStore int;
  retRow bestStoreForCatgoryRet;
  c1 cursor is (select distinct i_category from item where i_category is not null);
BEGIN
  open c1;
  fetch c1 into cat;
  WHILE found loop
    maxStore := (select ss_store_sk from (
									select ss_store_sk, count(*) as cnt
									from store_sales, item
									where ss_item_sk = i_item_sk and i_category = cat and ss_store_sk is not NULL
									group by ss_store_sk
									order by cnt desc
									limit 1)t);
    retRow := (cat, maxStore) :: bestStoreForCatgoryRet;
    fetch c1 into cat;
	RETURN NEXT retRow;
  END LOOP;

  RETURN;
END
$$ LANGUAGE PLPGSQL;