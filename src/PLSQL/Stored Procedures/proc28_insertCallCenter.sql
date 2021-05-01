CREATE or replace PROCEDURE InsertCallCenter ( strt_date date,  end_date date,  cc_closed_date int,  open_date int ,  cc_name varchar, 
									 ske int,  ide char,  cls varchar,  numEmpl int,  sz int,  hrs char, 
									 mgr varchar,  mkt_id int,  mkt_cls char,  mkt_desc varchar, 
									 Mktmanager varchar,  div int,  divName varchar,  company int,  company_name char,
									  st_num char, stName varchar, stType char,   cc_suite char,
									 city varchar,  county varchar,  stt char,  zip char, 
									 country varchar,  offs number,  taxPercent number)
is
    cnt int;
BEGIN	
    select count(*) into cnt from call_center where cc_call_center_sk =  ske;
	if (cnt=0) then
		insert into call_center values ( strt_date,  end_date,  cc_closed_date,  open_date,  cc_name,  ske,  ide,  cls,  numEmpl,  sz,  hrs, 
									 mgr,  mkt_id,  mkt_cls,  mkt_desc,  Mktmanager,  div,  divName,  company, 
									 company_name,  st_num, stName, stType,   cc_suite,  cit,  county,  stt,  zip,  country, 
									 offs,  taxPercent);
	end if;
END;