create procedure totalInventoryDefeciency
as
begin
	declare @webSales table(item_sk int, date_sk int, qty int)
	declare @catSales table(item_sk int, date_sk int, qty int)

	insert into @webSales
	select ws_item_sk, ws_sold_date_sk,sum(ws_quantity)
	from web_sales_history, date_dim
	where d_date_sk = ws_sold_date_sk and d_year>=2002 and d_year<=2003
	group by ws_sold_date_sk, ws_item_sk
	order by ws_item_sk

	insert into @catSales
	select cs_item_sk, cs_sold_date_sk,sum(cs_quantity)
	from catalog_sales_history, date_dim
	where d_date_sk = cs_sold_date_sk and d_year>=2002 and d_year<=2003
	group by cs_sold_date_sk, cs_item_sk
	order by cs_item_sk

	select  d as date_sk, i as item_sk, sum(addi) as def_amount
	from
		(select  t.date_sk as d, t.item_sk as i,  -1*sum(qty) as addi
		from
			(select item_sk, date_sk, qty
			from @webSales ws

			UNION ALL

			select item_sk,  date_sk, qty 
			from @catSales cs)t
		group by item_sk,  date_sk

		UNION ALL

		select inv_date_sk as d, inv_item_sk as i, sum(inv_quantity_on_hand) as addi 
		from inventory_history, date_dim
		where inv_date_sk=d_date_sk and  d_year>=2002 and d_year<=2003
		group by inv_date_sk, inv_item_sk)t2
	group by d, i
	having sum(addi)<0
	order by d, i
end
go