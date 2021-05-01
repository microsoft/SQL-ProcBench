--new return request

create or replace procedure processReturn
(channel char(1), item_sk int, cust_sk int, reason_sk int, orderNum int, returnQty int, returnReason char(100), 
retAmt decimal(7, 2), refundAmt decimal(7, 2))
language plpgsql
as $$
declare
	curDate date; 
	dateSk int; cnt int;
	randomString VARCHAR(16);
	reason_id varchar(16);
begin		
	curDate:=GETDATE();
	dateSk := (select d_date_sk from date_dim where d_date = curDate);
	if(channel='c') then
		insert into catalog_returns (cr_returned_date_sk, cr_item_sk, cr_refunded_customer_sk, cr_reason_sk, 
									cr_order_number, cr_return_quantity, cr_return_amt_inc_tax, cr_refunded_cash)
		values (dateSk, item_sk, cust_sk, reason_sk, orderNum, returnQty, retAmt, refundAmt);
	end if;
	if(channel='w') then
		insert into web_returns (wr_returned_date_sk, wr_item_sk, wr_refunded_customer_sk, wr_reason_sk, 
								wr_order_number, wr_return_quantity, wr_return_amt_inc_tax, wr_refunded_cash)
		values (dateSk, item_sk, cust_sk, reason_sk, orderNum, returnQty , retAmt, refundAmt);
	end if;
	select  count(*) into cnt from reason where r_reason_sk=reason_sk;
	if(cnt!=0) then
		return;
	else
		randomString := '';
		call CreateRandomString (randomString);
		reason_id :=  randomString;
		insert into reason (r_reason_sk, r_reason_id, r_reason_desc) values (reason_sk, reason_id, returnReason);
	end if;
end; $$