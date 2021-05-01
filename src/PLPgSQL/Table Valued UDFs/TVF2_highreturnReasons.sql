--Total of high(>1000) return amounts for return reasons pertaining to price issues for all three channels. (the the current non-history cycle)

CREATE TYPE highReturnReasonsRet AS (channel char(1), reason  varchar(10485760), totalAmount decimal(15, 2));

create or replace function highReturnReasons()
returns setof highReturnReasonsRet
as $$
DECLARE
	reason_store  varchar(10485760);
	total_store decimal(15, 2);
	reason_web  varchar(10485760);
	total_web decimal(15, 2);	
	reason_catalog  varchar(10485760);
	total_catalog decimal(15, 2);
	return_amt decimal(15, 2);
	des  varchar(10485760);
	retRow highReturnReasonsRet;
	c1 cursor is (select sr_return_amt, r_reason_desc from store_returns, reason
	where sr_reason_sk = r_reason_sk  and sr_return_amt>1000.0);
	
	c2 cursor is (select wr_return_amt, r_reason_desc from web_returns, reason
	where wr_reason_sk = r_reason_sk  and wr_return_amt>1000.0);
	
	c3 cursor is (select cr_return_amount, r_reason_desc from catalog_returns, reason
	where cr_reason_sk = r_reason_sk  and cr_return_amount>1000.0);
	
begin
	total_store := 0.0;
	reason_store :='';
	total_catalog := 0.0;
	reason_catalog := '';
	total_web := 0.0;
	reason_web := '';

	open c1;
	fetch c1 into return_amt, des;
	while found loop
		if(des like '%price%') then
			total_store := total_store + return_amt;
			reason_store := reason_store || des;
		end if;
		fetch c1 into return_amt, des;
	end loop;
	
	retRow := ('s', reason_store, total_store) :: highReturnReasonsRet;
	return next retRow;

	open c2;
	fetch c2 into return_amt, des;
	while found loop
		if(des like '%price%') then
			total_web := total_web + return_amt;
			reason_web := reason_web || des;
		end if;
		fetch c2 into return_amt, des;
	end loop;
	
	retRow := ('w', reason_web, total_web) :: highReturnReasonsRet;
	return next retRow;

	open c3;
	fetch c3 into return_amt, des;
	while found loop
		if(des like '%price%') then
			total_catalog := total_catalog + return_amt;
			reason_catalog := reason_catalog || des;
		end if;
		fetch c2 into return_amt, des;
	end loop;
	
	retRow := ('c', reason_catalog, total_catalog) :: highReturnReasonsRet;
	return next retRow;
	
end
$$ LANGUAGE PLPGSQL;
