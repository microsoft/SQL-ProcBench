create or alter procedure custTotalLoss(@returnReason char(100))
as
begin
	declare @orderNo int, @item int;
	declare @reasonSk int;
	declare @soldAmt decimal(7, 2), @retCredit decimal(7, 2);
	declare @totalCustLoss decimal(15, 0);
	
	set @totalCustLoss=0;
	set @reasonSk = (select r_reason_sk from reason where r_reason_desc=@returnReason);
	declare c1 cursor for (select wr_order_number, wr_item_sk, wr_refunded_cash from web_returns where wr_reason_sk=1);
	open c1;
	fetch next from c1 into @orderNo, @item, @retCredit;
	while(@@FETCH_STATUS=0)
	begin	
		set @soldAmt = (select ws_net_paid_inc_ship_tax from web_sales where ws_order_number = @orderNo and ws_item_sk=@item);
		set @totalCustLoss += @soldAmt - @retCredit ;
		fetch next from c1 into @orderNo, @item, @retCredit;
	end
	close c1;

	declare c2 cursor for (select cr_order_number, cr_item_sk, cr_refunded_cash from catalog_returns where cr_reason_sk=1);
	open c2;
	fetch next from c2 into @orderNo, @item, @retCredit;
	while(@@FETCH_STATUS=0)
	begin	
		set @soldAmt = (select cs_net_paid_inc_ship_tax from catalog_sales where cs_order_number = @orderNo and cs_item_sk=@item);
		set @totalCustLoss +=  @soldAmt - @retCredit;
		fetch next from c2 into @orderNo, @item, @retCredit;
	end
	select @totalCustLoss as totalLossToCustomer;

	close c2;
	deallocate c1;
	deallocate c2;
end