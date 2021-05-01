--for each store, find the income band of the customer who does maximum purchases(quantity wise)

create or alter function incomeBandOfMaxBuyCustomer(@storeNumber int)
returns varchar(50)
as 
begin 
	declare @incomeband int;
	declare @cust int;
	declare @hhdemo int;
	declare @cnt int;
	declare @cLevel varchar(50);
	select @cust = ss_customer_sk, @hhdemo = c_current_hdemo_sk, @cnt = count(*)
	from store_sales_history, customer
	where ss_store_sk = 1
		and c_customer_sk=ss_customer_sk
	group by ss_customer_sk, c_current_hdemo_sk
	having count(*) =(select max(cnt) from 
			(select ss_customer_sk, c_current_hdemo_sk, count(*) as cnt
			from store_sales_history, customer
			where ss_store_sk = 1
			and c_customer_sk=ss_customer_sk group by ss_customer_sk, c_current_hdemo_sk having ss_customer_sk IS NOT NULL ) tbl)

	set @incomeband = (select hd_income_band_sk from household_demographics where hd_demo_sk = @hhdemo);

	if(@incomeband>=0 and @incomeband<=3)
		set @cLevel = 'low';
	if(@incomeband>=4 and @incomeband<=7)
		set @cLevel = 'lowerMiddle';
	if(@incomeband>=8 and @incomeband<=11)
		set @cLevel = 'upperMiddle';
	if(@incomeband>=12 and @incomeband<=16)
		set @cLevel = 'high';
	if(@incomeband>=17 and @incomeband<=20)
		set @cLevel = 'affluent';
	
	return @cLevel;
end
go

--inovocation query
select s_store_sk from store where dbo.incomeBandOfMaxBuyCustomer(s_store_sk)='lowerMiddle' order by s_store_sk