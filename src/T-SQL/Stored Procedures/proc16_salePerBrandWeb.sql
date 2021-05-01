--Report the total extended sales price per item brand of a specific manufacturer for all web sales in a specific month
--of the year. 
CREATE PROCEDURE salePerBrandWeb (@year int, @month int, @manufacture int)
AS
BEGIN
	SET NOCOUNT ON;

	select i_brand, sum(ws_ext_sales_price) as totalSale
	from web_sales_history, item, date_dim
	where i_item_sk = ws_item_sk 
		and i_manufact_id = @manufacture
		and ws_sold_date_sk = d_date_sk
		and d_year = @year
		and d_moy = @month
	group by i_brand
END