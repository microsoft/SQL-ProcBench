--Calculate the average sales quantity, average sales price, average wholesale cost, total wholesale cost for store
--sales of different customer types (based on marital status and gender) from the given state.
CREATE or replace function excessReturns_web()
returns refcursor 
AS $$
declare 
	c1 refcursor := 'mycursor';
BEGIN
	open c1 for
	WITH ReturnTable 
			 AS (SELECT wr_returning_customer_sk,    
						ca_state,
						Sum(wr_return_amt) as returnAmt
				 FROM   web_returns_history,
						customer_address, 
						date_dim 
				 WHERE  wr_returned_date_sk = d_date_sk
						and wr_returning_addr_sk = ca_address_sk
						AND d_year = 2001 
				 GROUP  BY wr_returning_customer_sk, 
						   ca_state) 
	SELECT  c_customer_id, c_salutation, c_first_name, c_last_name, c_email_address, c_birth_year, c_birth_country
	FROM    ReturnTable tr1, 
			customer_address ca1, 
			customer
	WHERE  tr1.returnAmt > (SELECT Avg(returnAmt) * 1.2 
							FROM   ReturnTable tr2 
						    WHERE  tr1.ca_state = tr2.ca_state) 
			AND ca_address_sk = c_current_addr_sk
			AND tr1.wr_returning_customer_sk = c_customer_sk
			AND ca1.ca_state = 'TX' ;
	return c1;
END; $$
language plpgsql

BEGIN;
SELECT excessReturns_web();
FETCH ALL from mycursor;
COMMIT;