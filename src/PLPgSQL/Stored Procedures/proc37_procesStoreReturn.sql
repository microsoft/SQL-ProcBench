--new return request

create procedure processReturn_store
(item_sk int, cust_sk int, reason_sk int, ticketNum int, returnQty int, returnReason char(100))
language plpgsql
as $$
declare
	curDate date;
	dateSk int;
begin
	curdate:=GETDATE();
	dateSk := (select d_date_sk from date_dim where d_date = curDate);
	insert into store_returns (sr_returned_date_sk, sr_item_sk, sr_customer_sk, sr_reason_sk, sr_ticket_number, sr_return_quantity)
	values (dateSk, item_sk, cust_sk, reason_sk, ticketNum, returnQty);
	if exists (select * from reason where r_reason_sk=reason_sk) then
		return;
	else
		insert into reason (r_reason_sk, r_reason_desc) values (reason_sk, returnReason);
	end if;
end; $$
