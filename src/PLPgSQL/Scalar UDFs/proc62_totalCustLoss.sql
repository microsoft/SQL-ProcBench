create or replace function custTotalLoss(returnReason char(100))
returns refcursor
AS $$
declare 
	c3 refcursor := 'mycursor'; 
	orderNo int; item int;
	reasonSk int;
	soldAmt decimal(7, 2); retCredit decimal(7, 2);
	totalCustLoss decimal(15, 0);
	c1 cursor is (select wr_order_number, wr_item_sk, wr_refunded_cash from web_returns where wr_reason_sk=1);
	c2 cursor is (select cr_order_number, cr_item_sk, cr_refunded_cash from catalog_returns where cr_reason_sk=1);

begin	
	totalCustLoss:=0;
	reasonSk := (select r_reason_sk from reason where r_reason_desc=returnReason);
	open c1;
	fetch c1 into orderNo, item, retCredit;
	while found loop
		soldAmt := (select ws_net_paid_inc_ship_tax from web_sales where ws_order_number = orderNo and ws_item_sk=item);
		totalCustLoss := totalCustLoss+  soldAmt - retCredit ;
		fetch c1 into orderNo, item, retCredit;
	end loop;
	close c1;

	open c2;
	fetch c2 into orderNo, item, retCredit;
	while found loop
		soldAmt := (select cs_net_paid_inc_ship_tax from catalog_sales where cs_order_number = orderNo and cs_item_sk=item);
		totalCustLoss := totalCustLoss+  soldAmt - retCredit ;
		fetch c2 into orderNo, item, retCredit;
	end loop;
	close c2;
	
	open c3 for 
		select totalCustLoss; 
	return c3;
end; $$
language plpgsql