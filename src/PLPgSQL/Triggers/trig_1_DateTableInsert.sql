create or replace function dateTableTriggerFunc()
returns trigger as
$$
declare 
	vyear int; vmonth int; vday int; dDay int; dMonth int; dYear int;
	vdate date;
begin
	vyear := new.d_year;
	vmonth := new.d_moy;
	vday := new.d_dom;
	vdate := new.d_date;

	if(vyear is NULL or vyear<2100 or (vyear=2100 and vmonth=01 and vday=01)) then
		RAISE EXCEPTION 'illegal insert in date table';
	end if;

	if(vdate is NULL and (vyear is NULL or vmonth is NULL or vday is NULL)) then
		RAISE EXCEPTION 'cannot insert incomplete date information';
	end if;

	if(vdate is not NULL) then
		dDay := EXTRACT (DAY from vdate);
		dMonth := EXTRACT (MONTH from vdate);
		dYear := EXTRACT (YEAR from vdate);
		if((vyear is not NULL and vyear!=dYear) or (vmonth is not NULL and vmonth!=dMonth) or (vday is not NULL and vday!=dDay)) then
			RAISE EXCEPTION  'Inconsistent data values';
		end if;
	end if;
	return new;
end;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER dateTableChanges
after INSERT
ON date_dim
FOR EACH ROW
	execute procedure dateTableTriggerFunc();

--invocation
insert into date_dim (d_date_sk, d_date_id, d_date, d_year, d_moy, d_dom) values (3488070, 'ACHOFIRSYCHGRUFG', '3022-01-19', 3022, 01, 19);