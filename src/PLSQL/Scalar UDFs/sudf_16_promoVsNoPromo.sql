--through which channel was the ratio of promo vs non-promo items sold highest for a given year.
create or replace function promoVsNoPromoItems(givenYear number)
return varchar 
is
    promoCountWeb number; noPromoCountWeb number; promoCountCatalog number; noPromoCountCatalog number; promoCountStore number; noPromoCountStore number;
	ratioWeb number; ratioCatalog number; ratioStore number;
	maxRatio varchar(40);
begin

	select  sum(t1.cnt) into promoCountWeb
	from
	(select ws_item_sk, ws_promo_sk, count(*) as cnt
	from web_sales_history, promotion, date_dim
	where ws_sold_date_sk = d_date_sk 
		and d_year = givenYear
		and ws_promo_sk = p_promo_sk
		and p_channel_email='Y' or p_channel_catalog='Y' or p_channel_dmail='Y' --or p_channel_tv = 'Y'
	group by ws_item_sk, ws_promo_sk)t1;

	select sum(t1.cnt) into noPromoCountWeb
	from
	(select ws_item_sk, ws_promo_sk , count(*) as cnt
	from web_sales_history, promotion, date_dim
	where ws_sold_date_sk = d_date_sk 
		and d_year = 2000 
		and ws_promo_sk = p_promo_sk
		and p_channel_email='N' and p_channel_catalog='N' and p_channel_dmail='N'
	group by ws_item_sk, ws_promo_sk)t1;
	
	ratioWeb :=  promoCountWeb/noPromoCountWeb;

	select  sum(t1.cnt) into promoCountCatalog 
	from
	(select cs_item_sk, cs_promo_sk, count(*) as cnt
	from catalog_sales_history, promotion, date_dim
	where cs_sold_date_sk = d_date_sk 
		and d_year = givenYear
		and cs_promo_sk = p_promo_sk
		and p_channel_email='Y' or p_channel_catalog='Y' or p_channel_dmail='Y' --or p_channel_tv = 'Y'
	group by cs_item_sk, cs_promo_sk)t1;

	select  sum(t1.cnt) into noPromoCountCatalog
	from
	(select cs_item_sk, cs_promo_sk, count(*) as cnt
	from catalog_sales_history, promotion, date_dim 
	where cs_sold_date_sk = d_date_sk 
		and d_year = givenYear 
		and cs_promo_sk = p_promo_sk
		and p_channel_email='N' and p_channel_catalog='N' and p_channel_dmail='N' --or p_channel_tv = 'Y'
	group by cs_item_sk, cs_promo_sk)t1;

	ratioCatalog :=  promoCountCatalog/noPromoCountCatalog;

	select  sum(t1.cnt) into promoCountStore
	from
	(select ss_item_sk, ss_promo_sk , count(*) as cnt 
	from store_sales_history, promotion, date_dim
	where ss_sold_date_sk = d_date_sk 
		and d_year = givenYear
		and ss_promo_sk = p_promo_sk
		and p_channel_email='Y' or p_channel_catalog='Y' or p_channel_dmail='Y' --or p_channel_tv = 'Y'
	group by ss_item_sk, ss_promo_sk)t1;

	select  sum(t1.cnt) into noPromoCountStore
	from
	(select ss_item_sk, ss_promo_sk , count(*) as cnt   
	from store_sales_history, promotion, date_dim
	where ss_sold_date_sk = d_date_sk 
		and d_year = givenYear
		and ss_promo_sk = p_promo_sk
		and p_channel_email='N' and p_channel_catalog='N' and p_channel_dmail='N' --or p_channel_tv = 'Y'
	group by ss_item_sk, ss_promo_sk)t1;

	ratioStore :=  promoCountStore/noPromoCountStore;

	if(ratioWeb>ratioCatalog and ratioWeb>ratioStore) then
		maxRatio := 'Web';
    end if;
	if(ratioCatalog>ratioWeb and ratioCatalog>ratioStore) then
		maxRatio := 'Catalog';
    end if;
	if(ratioStore>ratioCatalog and ratioWeb<ratioStore) then
		maxRatio := 'Store';
    end if;
	return maxRatio;

end;


select PROMOVSNOPROMOITEMS(2001) from DUAL;