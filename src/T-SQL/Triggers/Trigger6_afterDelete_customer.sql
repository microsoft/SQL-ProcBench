CREATE or ALTER TRIGGER deleteCustomer ON customer
AFTER DELETE  
AS  
	declare @cust_sk int;
	declare c2 cursor static for (select c_customer_sk from DELETED);
	open c2;
	fetch next from c2 into @cust_sk;
	while(@@fetch_status=0)
	begin
		UPDATE web_page set wp_customer_sk=NULL where wp_customer_sk = @cust_sk;
		DELETE from web_returns where wr_refunded_customer_sk = @cust_sk or wr_returning_customer_sk=@cust_sk;
		DELETE from catalog_returns where cr_refunded_customer_sk = @cust_sk or cr_returning_customer_sk=@cust_sk;
		DELETE from store_returns where sr_customer_sk = @cust_sk;
		
		DELETE from web_sales where ws_bill_customer_sk = @cust_sk or ws_ship_customer_sk=@cust_sk;
		DELETE from catalog_sales where cs_bill_customer_sk = @cust_sk or cs_ship_customer_sk=@cust_sk;
		DELETE from store_sales where ss_customer_sk = @cust_sk;
		fetch next from c2 into @cust_sk;
	end
	close c2;
	deallocate c2;
GO 

--DML to invoke
delete from customer where c_customer_sk=1