--through which channel was the ratio of promo vs non-promo items sold highest for a given year.
CREATE OR REPLACE FUNCTION promoVsNoPromoItems(givenYear INT) 
RETURNS TEXT AS
$$
DECLARE
  promoCountWeb       INT8;
  noPromoCountWeb     INT8;
  promoCountCatalog   INT8;
  noPromoCountCatalog INT8;
  promoCountStore     INT8;
  noPromoCountStore   INT8;

  ratioWeb     FLOAT4;
  ratioCatalog FLOAT4;
  ratioStore   FLOAT4;

  maxRatio TEXT;
BEGIN

  promoCountWeb := (SELECT SUM(t1.cnt)
                    FROM (SELECT ws_item_sk, ws_promo_sk, COUNT(*) AS cnt
                          FROM web_sales_history, promotion, date_dim
                          WHERE ws_sold_date_sk = d_date_sk
                            AND d_year = givenYear
                            AND ws_promo_sk = p_promo_sk
                            AND p_channel_email='Y' OR p_channel_catalog='Y' OR p_channel_dmail='Y'
                          GROUP BY ws_item_sk, ws_promo_sk) AS t1);

  noPromoCountWeb := (SELECT SUM(t1.cnt)
                      FROM (SELECT ws_item_sk, ws_promo_sk , COUNT(*) AS cnt
                            FROM web_sales_history, promotion, date_dim
                            WHERE ws_sold_date_sk = d_date_sk
                              AND d_year = givenYear
                              AND ws_promo_sk = p_promo_sk
                              AND p_channel_email='N' AND p_channel_catalog='N' AND p_channel_dmail='N'
                            GROUP BY ws_item_sk, ws_promo_sk) AS t1);

  ratioWeb := (promoCountWeb :: FLOAT4) / (noPromoCountWeb :: FLOAT4);

  promoCountCatalog := (SELECT  SUM(t1.cnt)
                        FROM (SELECT cs_item_sk, cs_promo_sk, COUNT(*) AS cnt
                              FROM catalog_sale_history, promotion, date_dim
                              WHERE cs_sold_date_sk = d_date_sk
                                AND d_year = givenYear
                                AND cs_promo_sk = p_promo_sk
                                AND p_channel_email='Y' OR p_channel_catalog='Y' OR p_channel_dmail='Y' --or p_channel_tv = 'Y'
                              GROUP BY cs_item_sk, cs_promo_sk) AS t1);

  noPromoCountCatalog := (SELECT SUM(t1.cnt)
                          FROM (SELECT cs_item_sk, cs_promo_sk, COUNT(*) AS cnt
                                FROM catalog_sales_history, promotion, date_dim
                                WHERE cs_sold_date_sk = d_date_sk
                                  AND d_year = givenYear
                                  AND cs_promo_sk = p_promo_sk
                                  AND p_channel_email='N' AND p_channel_catalog='N' AND p_channel_dmail='N'
                                GROUP BY cs_item_sk, cs_promo_sk) AS t1);

  ratioCatalog := (promoCountCatalog :: FLOAT4) / (noPromoCountCatalog :: FLOAT4);

  promoCountStore := (SELECT SUM(t1.cnt)
                      FROM (SELECT ss_item_sk, ss_promo_sk , COUNT(*) AS cnt
                            FROM store_sales_history, promotion, date_dim
                            WHERE ss_sold_date_sk = d_date_sk
                              AND d_year = givenYear
                              AND ss_promo_sk = p_promo_sk
                              AND p_channel_email='Y' OR p_channel_catalog='Y' OR p_channel_dmail='Y'
                            GROUP BY ss_item_sk, ss_promo_sk) AS t1);

  noPromoCountStore := (SELECT SUM(t1.cnt)
                        FROM (SELECT ss_item_sk, ss_promo_sk , COUNT(*) AS cnt
                              FROM store_sales_history, promotion, date_dim
                              WHERE ss_sold_date_sk = d_date_sk
                                AND d_year = givenYear
                                AND ss_promo_sk = p_promo_sk
                                AND p_channel_email='N' AND p_channel_catalog='N' AND p_channel_dmail='N'
                              GROUP BY ss_item_sk, ss_promo_sk) AS t1);

  ratioStore := (promoCountStore :: FLOAT4) / (noPromoCountStore :: FLOAT4);

  IF ratioWeb >= ratioCatalog AND ratioWeb >= ratioStore THEN
    maxRatio := 'Web';
  ELSIF ratioCatalog >= ratioWeb AND ratioCatalog >= ratioStore THEN
    maxRatio := 'Catalog';
  ELSIF ratioStore >= ratioCatalog AND ratioWeb <= ratioStore THEN
    maxRatio := 'Store';
  END IF;

  RETURN maxRatio;
END
$$ LANGUAGE PLPGSQL;

--invocation
SELECT promoVsNoPromoItems(2001);