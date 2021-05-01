--process cancellation of an order from catalog and record reason in the reason table. 

create or replace procedure catalogOrderCancellation (item_sk int, orderNo int, reasonId int)
is
	shipDate date; curDate date;
	dateDiff int; reasonSk int;
	ide VARCHAR(16);
    cnt int;
begin
    select count(*) into cnt from catalog_sales where cs_item_sk=item_sk and cs_order_number=orderNo;
	if (cnt=0) then
		raise_application_error(-20111, 'invalid order');
		return;
	end if;
	select sysdate into curDate from dual;
	select d_date into shipDate from catalog_sales, date_dim 
					where cs_ship_date_sk=d_date_sk and cs_item_sk=item_sk and cs_order_number=orderNo;
	dateDiff := shipDate - curDate;
	if(dateDiff<=0) then
		raise_application_error (-20111, 'item already shipped. Try returning later.');
		return;
	else
		delete from catalog_sales where cs_item_sk=item_sk and cs_order_number=orderNo;
		select count(*) into cnt from reason where r_reason_sk=reasonId;
		if (cnt!=0) then
			return;
		else
			select max(r_reason_sk)+1 into reasonSk from reason;
			CreateRandomString (ide);
			insert into reason (r_reason_sk, r_reason_id) values (reasonSk, ide);
		end if;
	end if;
end;

