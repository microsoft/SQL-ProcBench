--process cancellation of an order from catalog and record reason in the reason table. 

create or replace procedure catalogOrderCancellation (item_sk int, orderNo int, reasonId int)
language plpgsql
as $$
declare
	shipDate date; curDate date;
	dateDiff int; reasonSk int;
	ide VARCHAR(16);
begin
	if not exists (select * from catalog_sales where cs_item_sk=item_sk and cs_order_number=orderNo) then
		raise exception 'invalid order';
		return;
	end if;
	curDate := CURRENT_DATE;
	shipDate := (select d_date from catalog_sales, date_dim 
					where cs_ship_date_sk=d_date_sk and cs_item_sk=item_sk and cs_order_number=orderNo);
	dateDiff := DATE_PART('day',  shipDate)-DATE_PART('day',  curDate);
	if(dateDiff<=0) then
		raise exception 'item already shippTry returning later.';
		return;
	else
		delete from catalog_sales where cs_item_sk=item_sk and cs_order_number=orderNo;
		if exists (select * from reason where r_reason_sk=reasonId) then
			return;
		else
			reasonSk := (select max(r_reason_sk)+1 from reason);
			call CreateRandomString (ide);
			insert into reason (r_reason_sk, r_reason_id) values (reasonSk, ide);
		end if;
	end if;
end; $$

