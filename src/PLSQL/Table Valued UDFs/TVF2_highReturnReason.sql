CREATE or REPLACE TYPE reason_o IS object(
   channel char(1), reason varchar2(32767),totalAmount number
);
/

Create or REPLACE type reason_t is TABLE OF reason_o;


create or replace function highReturnReasons
return reason_t
is
    reasonTable reason_t;
    
    reason_store clob; 
	total_store decimal(15, 2);
	reason_web clob; 
	total_web decimal(15, 2);	
	reason_catalog clob;
	total_catalog decimal(15, 2);
	
	return_amt decimal(15, 2);
	reason_desc clob;
    
    cursor c1 is 
        select sr_return_amt, r_reason_desc from store_returns, reason where sr_reason_sk = r_reason_sk  and sr_return_amt>1000.0;
    
    cursor c2 is 
        select wr_return_amt, r_reason_desc from web_returns, reason where wr_reason_sk = r_reason_sk  and wr_return_amt>1000.0;
        
    cursor c3 is 
        select cr_return_amount, r_reason_desc from catalog_returns, reason where cr_reason_sk = r_reason_sk  and cr_return_amount>1000.0;
	
begin
     total_store := 0.0;
	 reason_store := '';
	 total_catalog := 0.0;
	 reason_catalog := '';
	 total_web := 0.0;
	 reason_web := '';
     
     open c1;
     loop
        fetch c1 into return_amt,reason_desc;
        if(reason_desc like '%price%') then
            total_store := total_store + return_amt;
			reason_store := reason_store || reason_desc;
        end if;
	end loop;
    
    close c1;
    reasonTable.extend;
	reasonTable(reasonTable.last) := reason_o('s', reason_store, total_store);
    
	

	open c2;
    loop
        fetch c2 into return_amt,reason_desc;
		if(reason_desc like '%price%') then
			total_web := total_web + return_amt;
			reason_web := reason_web || reason_desc;
		end if;
	end loop;

    close c2;
    reasonTable.extend;
	reasonTable(reasonTable.last) := reason_o('w', reason_web, total_web);

	open c3;
    loop
        fetch c3 into return_amt,reason_desc;
		if(reason_desc like '%price%') then
			total_catalog := total_catalog + return_amt;
			reason_catalog := reason_catalog || reason_desc;
		end if;
	end loop;

    close c3;
    
    reasonTable.extend;
	reasonTable(reasonTable.last) :=  reason_o('c', reason_catalog, total_catalog);
	
    return reasonTable;
end;

select channel, reason, totalAmount
from highReturnReasons()