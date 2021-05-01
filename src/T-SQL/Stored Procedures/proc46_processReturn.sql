--new return request

create or alter procedure processReturn
(@channel char(1), @item_sk int, @cust_sk int, @reason_sk int, @orderNum int, @returnQty int, @returnReason char(100), 
@retAmt decimal(7, 2), @refundAmt decimal(7, 2))
as
begin
	declare @curDate date = GETDATE();
	declare @dateSk int, @cnt int;
	set @dateSk = (select d_date_sk from date_dim where d_date = @curDate);
	if(@channel='c')
	begin
		insert into catalog_returns (cr_returned_date_sk, cr_item_sk, cr_refunded_customer_sk, cr_reason_sk, 
									cr_order_number, cr_return_quantity, cr_return_amt_inc_tax, cr_refunded_cash)
		values (@dateSk, @item_sk, @cust_sk, @reason_sk, @orderNum, @returnQty, @retAmt, @refundAmt);
	end
	if(@channel='w')
	begin
		insert into web_returns (wr_returned_date_sk, wr_item_sk, wr_refunded_customer_sk, wr_reason_sk, 
								wr_order_number, wr_return_quantity, wr_return_amt_inc_tax, wr_refunded_cash)
		values (@dateSk, @item_sk, @cust_sk, @reason_sk, @orderNum, @returnQty , @retAmt, @refundAmt);
	end
	select @cnt = count(*) from reason where r_reason_sk=@reason_sk
	if(@cnt!=0)
		return;
	else
	begin
		declare @randomString VARCHAR(16);
		declare @reason_id varchar(16);
		EXEC [dbo].[CreateRandomString] @randomString OUTPUT;
		SELECT @reason_id =  @randomString;
		insert into reason (r_reason_sk, r_reason_id, r_reason_desc) values (@reason_sk, @reason_id, @returnReason);
	end
end

--invocation query
exec dbo.processReturn 'c', 123, 234, 50, 12, 2, 'did not like it', 245.56, 240.43