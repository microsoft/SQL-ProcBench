create or replace function maxPromoChannel(year int)
return varchar
is
begin
	return promoVsNoPromoItems(year);
end;

--invocation query
select maxPromoChannel(2001) from DUAL;