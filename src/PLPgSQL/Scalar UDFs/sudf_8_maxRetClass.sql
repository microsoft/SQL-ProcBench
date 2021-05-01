--Class of items that is returned the most on catalog in the curent cycle (non-history).

CREATE OR REPLACE FUNCTION maxReturnClass() RETURNS CHAR (50) AS
$$
DECLARE
  count INT8;
  class CHAR(50);
  maxClass CHAR(50);
  maxReturn INT8 := 0;
  c1 CURSOR FOR (SELECT i_class, COUNT(i_class) AS cnt
                FROM   catalog_returns, item
                WHERE  i_item_sk = cr_item_sk
                GROUP BY i_class
                );
BEGIN

  OPEN c1;
  FETCH c1 INTO class, count;

  WHILE found LOOP
    IF count > maxReturn THEN
      maxReturn := count;
      maxClass  := class;
    END IF;
    FETCH c1 INTO class, count;
  END LOOP;

  RETURN maxClass;
END
$$ LANGUAGE PLPGSQL;