--through which channel was the ratio of promo vs non-promo items sold highest for a given year.

create or alter function promoVsNoPromoItems(@givenYear integer)
returns varchar(40)
as
begin
	declare @promoCountWeb int, @noPromoCountWeb int, @promoCountCatalog int, @noPromoCountCatalog int, @promoCountStore int, @noPromoCountStore int
	declare @ratioWeb float, @ratioCatalog float, @ratioStore float;
	declare @maxRatio varchar(40);

	select @promoCountWeb = sum(t1.cnt)
	from
	(select ws_item_sk, ws_promo_sk, count(*) as cnt
	from web_sales_history, promotion, date_dim
	where ws_sold_date_sk = d_date_sk 
		and d_year = @givenYear
		and ws_promo_sk = p_promo_sk
		and p_channel_email='Y' or p_channel_catalog='Y' or p_channel_dmail='Y' 
	group by ws_item_sk, ws_promo_sk)t1;

	select @noPromoCountWeb = sum(t1.cnt)
	from
	(select ws_item_sk, ws_promo_sk , count(*) as cnt
	from web_sales_history, promotion, date_dim
	where ws_sold_date_sk = d_date_sk 
		and d_year = @givenYear 
		and ws_promo_sk = p_promo_sk
		and p_channel_email='N' and p_channel_catalog='N' and p_channel_dmail='N'
	group by ws_item_sk, ws_promo_sk)t1;
	
	set @ratioWeb =  CAST(@promoCountWeb AS float) / CAST(@noPromoCountWeb AS float);

	select @promoCountCatalog =  sum(t1.cnt)
	from
	(select cs_item_sk, cs_promo_sk, count(*) as cnt
	from catalog_sales_history, promotion, date_dim
	where cs_sold_date_sk = d_date_sk 
		and d_year = @givenYear
		and cs_promo_sk = p_promo_sk
		and p_channel_email='Y' or p_channel_catalog='Y' or p_channel_dmail='Y'
	group by cs_item_sk, cs_promo_sk)t1;

	select @noPromoCountCatalog =  sum(t1.cnt)
	from
	(select cs_item_sk, cs_promo_sk, count(*) as cnt
	from catalog_sales_history, promotion, date_dim 
	where cs_sold_date_sk = d_date_sk 
		and d_year = @givenYear 
		and cs_promo_sk = p_promo_sk
		and p_channel_email='N' and p_channel_catalog='N' and p_channel_dmail='N' 
	group by cs_item_sk, cs_promo_sk)t1;

	set @ratioCatalog=  CAST(@promoCountCatalog AS float) / CAST(@noPromoCountCatalog AS float);

	select @promoCountStore =  sum(t1.cnt)
	from
	(select ss_item_sk, ss_promo_sk , count(*) as cnt 
	from store_sales_history, promotion, date_dim
	where ss_sold_date_sk = d_date_sk 
		and d_year = @givenYear
		and ss_promo_sk = p_promo_sk
		and p_channel_email='Y' or p_channel_catalog='Y' or p_channel_dmail='Y' --or p_channel_tv = 'Y'
	group by ss_item_sk, ss_promo_sk)t1;

	select @noPromoCountStore =  sum(t1.cnt)
	from
	(select ss_item_sk, ss_promo_sk , count(*) as cnt   
	from store_sales_history, promotion, date_dim
	where ss_sold_date_sk = d_date_sk 
		and d_year = @givenYear
		and ss_promo_sk = p_promo_sk
		and p_channel_email='N' and p_channel_catalog='N' and p_channel_dmail='N' --or p_channel_tv = 'Y'
	group by ss_item_sk, ss_promo_sk)t1;

	set @ratioStore=  CAST(@promoCountStore AS float) / CAST(@noPromoCountStore AS float);

	if(@ratioWeb>=@ratioCatalog and @ratioWeb>=@ratioStore)
	begin
		set @maxRatio = 'Web';
	end
	else if(@ratioCatalog>=@ratioWeb and @ratioCatalog>=@ratioStore)
	begin
		set @maxRatio = 'Catalog';
	end
	else if(@ratioStore>=@ratioCatalog and @ratioWeb<=@ratioStore)
	begin
		set @maxRatio = 'Store';
	end
	return @maxRatio;

end
go

--invocation query
select dbo.promoVsNoPromoItems(2001) as ans;
