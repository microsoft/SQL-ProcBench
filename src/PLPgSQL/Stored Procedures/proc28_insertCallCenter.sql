CREATE PROCEDURE InsertCallCenter ( strt_date date,  end_date date,  cc_closed_date int,  open_date int ,  cc_name varchar(50), 
									 sk int,  id char(16),  class varchar(50),  numEmpl int,  size int,  hrs char(20), 
									 manager varchar(40),  mkt_id int,  mkt_cls char(50),  mkt_desc varchar(100), 
									 Mktmanager varchar(40),  div int,  divName varchar(50),  company int,  company_name char(50),
									  st_num char(10), stName varchar(60), stType char(15),   cc_suite char(10),
									 city varchar(60),  county varchar(30),  stat char(2),  zip char(10), 
									 country varchar(20),  offs decimal(5,2),  taxPercent decimal(5,2))
language plpgsql
as $$
BEGIN	
	if not exists (select * from call_center where cc_call_center_sk =  sk) then
		insert into call_center values ( strt_date,  end_date,  cc_closed_date,  open_date,  cc_name,  sk,  id,  class,  numEmpl,  size,  hrs, 
									 manager,  mkt_id,  mkt_cls,  mkt_desc,  Mktmanager,  div,  divName,  company, 
									 company_name,  st_num, stName, stType,   cc_suite,  cit,  county,  stat,  zip,  country, 
									 offs,  taxPercent);
	end if;
END; $$