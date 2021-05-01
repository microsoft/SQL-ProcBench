create procedure new_promotion( item_sk int,  start_date int,  end_date int,  cst number)
is
	newSk int;  maxSk int;
begin
	select max(p_promo_sk) into maxSk from promotion;
	newSk :=  maxSk+1;

	insert into promotion(p_promo_sk, p_start_date_sk, p_end_date_sk, p_item_sk, p_cost, p_discount_active)
	values ( newSk,  start_date,  end_date,  item_sk,  cst, 'Y');
end; 