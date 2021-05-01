--For catalog items sold in a given month of a year that have deficient stock in inventory,
--find out how many of these were also ordered in large amounts through the web channel.


--invocation query
SELECT month, highDeficiencyAmount(month)
FROM   generate_series(1,12) AS _(month);

CREATE OR REPLACE FUNCTION highDeficiencyAmount(mnth INT)
RETURNS INT8 AS
$$
DECLARE
BEGIN
  RETURN (SELECT COUNT(*) FROM highDeficiencyAmountWebItemTable(mnth) WHERE defType = 'high deficiency');
END
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION highDeficiencyAmountWebItemTable(month INT)
RETURNS TABLE (item INT8, qty INT8, defType VARCHAR(40)) AS
$$
DECLARE
  item INT8;
  amt INT8;
  availableQty INT8;
  catDefItem INT8;
  highDemandCount INT8;
  web_qty INT8;
BEGIN
  FOR catDefItem IN (SELECT * FROM highDeficiencyAmountItems(month)) LOOP
    web_qty := (select sum(ws_quantity)
                from web_sales, date_dim
                where d_date_sk = ws_sold_date_sk
                  and d_moy = month
                  and ws_item_sk = catDefItem);

    IF web_qty > 0 THEN
      IF web_qty < 5 THEN
        RETURN QUERY (SELECT catDefItem, web_qty, 'low deficiency');
      ELSIF web_qty < 10 THEN
        RETURN QUERY (SELECT catDefItem, web_qty, 'medium deficiency');
      ELSE
        RETURN QUERY (SELECT catDefItem, web_qty, 'high deficiency');
      END IF;
    END IF;
  END LOOP;
  RETURN;
END
$$ LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION highDeficiencyAmountItems(month INT)
RETURNS TABLE (item INT8, deficiency INT8) AS
$$
DECLARE
  item INT8;
  amt INT8;
  availableQty INT8;
  catDefItem INT8;
  highDemandCount INT8;
  web_qty INT8;
BEGIN
  FOR item, amt IN (select cs_item_sk, sum(cs_quantity) as ordered_amt
            from catalog_sales, date_dim
            where d_date_sk = cs_sold_date_sk
              and d_moy = month
            group by cs_item_sk) LOOP

    availableQty := (select sum(inv_quantity_on_hand) from inventory, date_dim
                    where inv_item_sk = item
                      and inv_date_sk = d_date_sk
                      and d_moy = month);

    IF availableQty < amt THEN
      RETURN QUERY (SELECT item, amt-availableQty);
    END IF;
  END LOOP;
  RETURN;
END
$$ LANGUAGE PLPGSQL;

