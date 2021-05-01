create or replace function incomeBandOfMaxBuyCustomer(storeNumber number)
return varchar
is
    pragma udf;
    incomeband number;
	cust number;
	hhdemo number;
	cnt number;
	cLevel varchar(50);
begin 
	select ss_customer_sk , c_current_hdemo_sk , count(*) 
    into cust, hhdemo, cnt
	from store_sales_history, customer
	where ss_store_sk = 1 and c_customer_sk=ss_customer_sk
	group by ss_customer_sk, c_current_hdemo_sk
	having count(*) =(select max(cnt) from 
			(select ss_customer_sk, c_current_hdemo_sk, count(*) as cnt
			from store_sales_history, customer
			where ss_store_sk = 1
			and c_customer_sk=ss_customer_sk group by ss_customer_sk, c_current_hdemo_sk having ss_customer_sk IS NOT NULL ) tbl);
    
    select hd_income_band_sk into incomeband from household_demographics where hd_demo_sk = hhdemo;


	if(incomeband>=0 and incomeband<=3) then
		 cLevel := 'low';
    end if;
	if(incomeband>=4 and incomeband<=7) then
		 cLevel := 'lowerMiddle';
	end if;
    if(incomeband>=8 and incomeband<=11) then
		 cLevel := 'upperMiddle';
	end if;
    if(incomeband>=12 and incomeband<=16) then
		 cLevel := 'high';
	end if;
    if(incomeband>=17 and incomeband<=20) then
		 cLevel := 'affluent';
	end if;
	return cLevel;
end;

select s_store_sk from store where incomeBandOfMaxBuyCustomer(s_store_sk)='lowerMiddle' order by s_store_sk

