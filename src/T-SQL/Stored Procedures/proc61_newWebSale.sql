--new web sale record.
create procedure newWebSale(@item_sk int, @cust_sk int, @custname char(10), @page_sk int, @promo_sk int, 
							  @qty int, @listPrice decimal(7, 2), @sp decimal(7, 2), @npaid decimal(7, 2), 
							  @profit decimal(7, 2), @streetnum char(10), @suite char(10), @city varchar(60),
								@county varchar(30), @state char(2), @zip char(10))
as
begin
	set nocount on;
	declare @curDate date;
	declare @dateSk int, @hr int, @mn int, @sc int, @timeSk int, @addr_sk int;
	declare @curTime time;
	declare @adr_id varchar(16), @cus_id varchar(16);
	set @hr = (select DATEPART(hour, GETDATE()));
	set @mn = (select DATEPART(MINUTE, GETDATE()));
	set @sc = (select DATEPART(SECOND, GETDATE()));
	set @curDate = GETDATE();
	set @dateSk = (select d_date_sk from date_dim where d_date=@curDate);
	set @timeSk = (select t_time_sk from time_dim where t_hour= @hr and t_minute=@mn and t_second=@sc);
	
	--this is a new customer
	if(@cust_sk=NULL)
	begin	
		set @cust_sk = (select max(c_customer_sk)+1 from customer);
		set @addr_sk = (select max(ca_address_sk)+1 from customer_address);
		DECLARE @chars VARCHAR(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		declare @randomString VARCHAR(16);

		EXEC [dbo].[CreateRandomString] @randomString OUTPUT;
		SELECT @adr_id =  @randomString;

		insert into customer_address(ca_address_sk, ca_address_id, ca_street_number, ca_suite_number, 
									ca_city, ca_county, ca_state, ca_zip)
		values (@addr_sk, @adr_id, @streetnum, @suite, @city, @county, @state, @zip);

		EXEC [dbo].[CreateRandomString] @randomString OUTPUT;
		SELECT @cus_id =  @randomString;

		insert into customer(c_customer_sk, c_customer_id, c_first_name, c_current_addr_sk)
		values (@cust_sk, @cus_id, @custname, @addr_sk);
	end

	else
	begin
		set @addr_sk = (select c_current_addr_sk from customer where c_customer_sk=@cust_sk)
	end

	insert into web_sales (ws_sold_date_sk, ws_sold_time_sk, ws_item_sk, ws_bill_customer_sk, ws_ship_addr_sk, ws_web_page_sk,
							ws_promo_sk, ws_quantity, ws_list_price, ws_sales_price, ws_net_paid, ws_net_profit)
	values (@dateSk, @timeSk, @item_sk, @cust_sk, @addr_sk, @page_sk, @promo_sk, @qty, @listPrice, @sp, @npaid, @profit);
end