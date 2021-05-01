--process cancellation of an order fromm web and record reason in the reason table.
 
create or replace procedure webOrderCancellation (item_sk int, orderNo int, reasonId int)
language plpgsql
as $$
declare
	shipDate date; curDate date;
	dateDiff int; reasonSk int;
	ide VARCHAR(16);
begin
	if not exists (select * from web_sales where ws_item_sk=item_sk and ws_order_number=orderNo) then
		raise exception 'invalid order';
		return;
	end if;
	curDate := CURRENT_DATE;
	shipDate := (select d_date from web_sales, date_dim 
					where ws_ship_date_sk=d_date_sk and ws_item_sk=item_sk and ws_order_number=orderNo);
	dateDiff := DATE_PART('day',  shipDate)-DATE_PART('day',  curDate);
	if(dateDiff<=0) then
		raise exception 'item already shipped. Try returning later.';
		return;
	else
		delete from web_sales where ws_item_sk=item_sk and ws_order_number=orderNo;
		if exists (select * from reason where r_reason_sk=reasonId) then
			return;
		else
			reasonSk := (select max(r_reason_sk)+1 from reason);
			call CreateRandomString (ide);
			insert into reason (r_reason_sk, r_reason_id) values (reasonSk, ide);
		end if;
	end if;
end; $$