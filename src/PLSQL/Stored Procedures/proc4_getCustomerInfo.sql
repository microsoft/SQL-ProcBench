create or replace procedure getCustomerInfo(custKey int)
AS  c1 sys_refcursor;
BEGIN
    open c1 for 
	select c_salutation, c_first_name, c_last_name, c_birth_year, c_email_address, 
			ca_street_number, ca_street_name, ca_suite_number, ca_city, ca_county, ca_country
	from customer, customer_address
	where c_current_addr_sk = ca_address_sk
		and c_customer_sk = custKey;
        
     dbms_sql.return_result(c1);
end; 