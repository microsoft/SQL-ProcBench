--analyse the profit of a store for a given duration.

CREATE TYPE profitMonitoringRet AS (dt DATE, profit DECIMAL(15,2));

CREATE OR REPLACE FUNCTION profitMonitoring(startDate DATE, endDate DATE, givenStore INT)
RETURNS SETOF profitMonitoringRet AS
$$
DECLARE
  dateSk INT;
  dayProfit DECIMAL(15,2);
  retRow profitMonitoringRet;
BEGIN

  IF startDate > endDate THEN
    RETURN;
  END IF;

  WHILE startDate <= endDate LOOP
    dateSk := (SELECT d_date_sk FROM date_dim WHERE d_date = startDate);
    dayProfit := (SELECT SUM(ss_net_profit)
                  FROM store_sales
                  WHERE ss_sold_date_sk = dateSk
                    AND ss_store_sk = givenStore);
    retRow := (startDate, dayProfit) :: profitMonitoringRet;
    RETURN NEXT retRow;
    startDate := (startDate + interval '1 day') :: DATE;
  END LOOP;

  RETURN;
END
$$ LANGUAGE PLPGSQL;