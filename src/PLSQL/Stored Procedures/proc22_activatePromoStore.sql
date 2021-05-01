create or replace procedure activatePromoStore
is
	promo_sk int;
	cursor c1 is select promo_sk from bestPromoStore(); 
begin
	open c1;
	loop
        fetch c1 into promo_sk;
        
        exit when c1%NOTFOUND;
		
        update promotion set p_end_date_sk = 10000000, p_discount_active='Y'
		where p_promo_sk = promo_sk;		
	end	LOOP;
    close c1;
end;