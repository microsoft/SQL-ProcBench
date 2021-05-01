--Report the total extended sales price per item brand of a specific manufacturer for all catalog sales in a specific month
--of the year. 
CREATE or replace function salePerBrandCatalog (yr int, mnth int, manufacture int)
returns refcursor
AS $$
declare 
	c1 refcursor := 'mycursor';
begin
	open c1 for 
	select i_brand, sum(cs_ext_sales_price) as totalSale
	from catalog_sales_history, item, date_dim
	where i_item_sk = cs_item_sk 
		and i_manufact_id = manufacture
		and cs_sold_date_sk = d_date_sk
		and d_year = yr
		and d_moy = mnth
	group by i_brand; 
	
	return c1;
END; $$
language plpgsql