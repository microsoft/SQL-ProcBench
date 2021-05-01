create or alter function maxPromoChannel(@year int)
returns varchar(20)
as
begin
	return dbo.promoVsNoPromoItems(@year);
end
go

--invocation query
select dbo.maxPromoChannel(2001);
go
