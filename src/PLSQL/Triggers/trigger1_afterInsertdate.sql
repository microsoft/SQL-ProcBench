CREATE or REPLACE TRIGGER dateTableChanges 
AFTER INSERT
ON date_dim
FOR EACH ROW
DECLARE
	vyear int; vmonth int; vday int; dDay int; dMonth int; dYear int;
	vdate date;
BEGIN
	vyear := :new.d_year;
	vmonth := :new.d_moy;
	vday := :new.d_dom;
	vdate := :new.d_date;

	if(vyear is NULL or vyear<2100 or (vyear=2100 and vmonth=01 and vday=01)) then
		raise_application_error(-20100, 'illegal insert in date table');
		return;
	end if;

	if(vdate is NULL and (vyear is NULL or vmonth is NULL or vday is NULL)) then
		raise_application_error(-20100, 'cannot insert incomplete date information');
		return;
	end if;

	if(vdate is not NULL) then
		dDay := EXTRACT (DAY from vdate);
		dMonth := EXTRACT (MONTH from vdate);
		dYear := EXTRACT (YEAR from vdate);
		if((vyear is not NULL and vyear!=dYear) or (vmonth is not NULL and vmonth!=dMonth) or (vday is not NULL and vday!=dDay)) then
			raise_application_error(-20100, 'Inconsistent data values');
			return;
		end if;
	end if;
END;

--invocation query
insert into date_dim (d_date_sk, d_date_id, d_date, d_year, d_moy, d_dom) values (3488073, 'ACHOFIRSYCHGRUFG', '19-JAN-3020', 3020, 01, 19);