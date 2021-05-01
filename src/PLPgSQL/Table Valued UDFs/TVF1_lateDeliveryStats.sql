--Output the late delivery statistics of each of the 2 delivery channels

CREATE TYPE deliveryStatsType AS
  ( warehouseName VARCHAR(20)
  , shipMode CHAR(30)
  , thirty_days INT8
  , sixty_days INT8
  , ninety_days INT8
  , oneTwenty_days INT8
  , veryLate INT8
  );

CREATE OR REPLACE FUNCTION ChannelWiseLateDeliveryStatistics(channel CHAR(1), year INT4)
RETURNS SETOF deliveryStatsType AS
$$
BEGIN

  IF channel = 'c' THEN
    RETURN QUERY
      ( SELECT w_warehouse_name, sm_type,
            Sum(CASE
                WHEN ( cs_ship_date_sk - cs_sold_date_sk <= 30 ) THEN 1
                ELSE 0
              END) AS thirty_days,
            Sum(CASE
                WHEN ( cs_ship_date_sk - cs_sold_date_sk > 30 )
                  AND ( cs_ship_date_sk - cs_sold_date_sk <= 60 ) THEN 1
                ELSE 0
              END) AS sixty_days,
            Sum(CASE
                WHEN ( cs_ship_date_sk - cs_sold_date_sk > 60 )
                  AND ( cs_ship_date_sk - cs_sold_date_sk <= 90 ) THEN 1
                ELSE 0
              END) AS ninety_days,
            Sum(CASE
                WHEN ( cs_ship_date_sk - cs_sold_date_sk > 90 )
                  AND ( cs_ship_date_sk - cs_sold_date_sk <= 120 ) THEN
                1
                ELSE 0
              END) AS oneTwenty_days,
            Sum(CASE
                WHEN ( cs_ship_date_sk - cs_sold_date_sk > 120 ) THEN 1
                ELSE 0
              END) AS veryLateDelivery

          FROM   catalog_sales, warehouse, ship_mode, date_dim
          WHERE  d_year BETWEEN year AND year+5
               AND cs_ship_date_sk = d_date_sk
               AND cs_warehouse_sk = w_warehouse_sk
               AND cs_ship_mode_sk = sm_ship_mode_sk
          GROUP  BY w_warehouse_name,
                sm_type
      );
  ELSEIF channel = 'w' THEN
    RETURN QUERY
      ( SELECT w_warehouse_name, sm_type,
          Sum(CASE
              WHEN ( ws_ship_date_sk - ws_sold_date_sk <= 30 ) THEN 1
              ELSE 0
            END) AS thirty_days,
          Sum(CASE
              WHEN ( ws_ship_date_sk - ws_sold_date_sk > 30 )
                AND ( ws_ship_date_sk - ws_sold_date_sk <= 60 ) THEN 1
              ELSE 0
            END) AS sixty_days,
          Sum(CASE
              WHEN ( ws_ship_date_sk - ws_sold_date_sk > 60 )
                AND ( ws_ship_date_sk - ws_sold_date_sk <= 90 ) THEN 1
              ELSE 0
            END) AS ninety_days,
          Sum(CASE
              WHEN ( ws_ship_date_sk - ws_sold_date_sk > 90 )
                AND ( ws_ship_date_sk - ws_sold_date_sk <= 120 ) THEN
              1
              ELSE 0
            END) AS oneTwenty_days,
          Sum(CASE
              WHEN ( ws_ship_date_sk - ws_sold_date_sk > 120 ) THEN 1
              ELSE 0
            END) AS veryLateDelivery
        FROM   web_sales,
             warehouse,
             ship_mode,
             date_dim
        WHERE  d_year BETWEEN year AND year+5
             AND ws_ship_date_sk = d_date_sk
             AND ws_warehouse_sk = w_warehouse_sk
             AND ws_ship_mode_sk = sm_ship_mode_sk
        GROUP  BY w_warehouse_name,
              sm_type
      );
  END IF;
END
$$ LANGUAGE PLPGSQL;