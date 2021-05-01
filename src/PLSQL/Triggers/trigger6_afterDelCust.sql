CREATE or REPLACE TRIGGER deleteCustomer 
AFTER DELETE
ON customer
FOR EACH ROW
BEGIN
		UPDATE web_page set wp_customer_sk=NULL where wp_customer_sk = :old.c_customer_sk;
		DELETE from web_returns where wr_refunded_customer_sk = :old.c_customer_sk or wr_returning_customer_sk=:old.c_customer_sk;
		DELETE from catalog_returns where cr_refunded_customer_sk = :old.c_customer_sk or cr_returning_customer_sk=:old.c_customer_sk;
		DELETE from store_returns where sr_customer_sk = :old.c_customer_sk;
		
		DELETE from web_sales where ws_bill_customer_sk = :old.c_customer_sk or ws_ship_customer_sk=:old.c_customer_sk;
		DELETE from catalog_sales where cs_bill_customer_sk = :old.c_customer_sk or cs_ship_customer_sk=:old.c_customer_sk;
		DELETE from store_sales where ss_customer_sk =:old.c_customer_sk;
END;


--invocation query
delete from customer where c_customer_sk=1;