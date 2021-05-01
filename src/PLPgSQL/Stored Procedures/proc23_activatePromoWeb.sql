create or replace procedure activatePromoWeb()
language plpgsql
as $$
declare
	promo_sk int;
	c1 cursor for (select promo_sk from bestPromosWeb()); 
begin
	open c1;
	fetch c1 into promo_sk;
	while found LOOP
		update promotion set p_end_date_sk = 10000000, p_discount_active='Y'
		where p_promo_sk = @promo_sk;

		fetch c1 into promo_sk;
	end	LOOP;
end; $$
