create or alter procedure activatePromoWeb
as
begin
	declare @promo_sk int;
	declare c1 cursor static for (select promo_sk from dbo.bestPromosWeb());
	open c1;
	fetch next from c1 into @promo_sk;
	while(@@FETCH_STATUS=0)
	begin
		update promotion set p_end_date_sk = 10000000, p_discount_active='Y'
		where p_promo_sk = @promo_sk;

		fetch next from c1 into @promo_sk;
	end	
	CLOSE C1;
	DEALLOCATE C1;
end
go