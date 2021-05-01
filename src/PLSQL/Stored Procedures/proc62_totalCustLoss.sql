create or replace procedure custTotalLoss(returnReason char)
as 
    c3 sys_refcursor; 
	orderNo int; item int;
	reasonSk int;
	soldAmt decimal(7, 2); retCredit decimal(7, 2);
	totalCustLoss decimal(15, 0); totalLossAns decimal(15, 0);
    cursor c1 is 
        select wr_order_number, wr_item_sk, wr_refunded_cash from web_returns where wr_reason_sk=1;
    cursor c2 is 
        select cr_order_number, cr_item_sk, cr_refunded_cash from catalog_returns where cr_reason_sk=1;
begin	
	totalCustLoss :=0 ;
	select r_reason_sk into reasonSk from reason where r_reason_desc=returnReason;
	open c1;
    loop
        fetch c1 into orderNo, item, retCredit;
        exit when c1%NOTFOUND;
		select ws_net_paid_inc_ship_tax into soldAmt from web_sales where ws_order_number = orderNo and ws_item_sk=item;
		totalCustLoss := totalCustLoss + soldAmt - retCredit ;
	end loop;
	close c1;

	open c2;
    loop
        fetch c2 into orderNo, item, retCredit;
        exit when c1%NOTFOUND;
		select cs_net_paid_inc_ship_tax into soldAmt from catalog_sales where cs_order_number = orderNo and cs_item_sk=item;
		totalCustLoss := totalCustLoss + soldAmt - retCredit ;
	end loop;
    close c2;
    
    open c3 for 
	select totalCustLoss into totalLossAns from dual;
    
    dbms_sql.return_result(c3);
end;