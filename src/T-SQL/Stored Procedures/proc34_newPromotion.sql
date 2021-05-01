create procedure new_promotion(@item_sk int, @start_date int, @end_date int, @cost decimal(15, 2))
as
begin
	set nocount on;
	declare @newSk int, @maxSk int;
	set @maxSk = (select max(p_promo_sk) from promotion);

	set @newSk = @maxSk+1;

	insert into promotion(p_promo_sk, p_start_date_sk, p_end_date_sk, p_item_sk, p_cost, p_discount_active)
	values (@newSk, @start_date, @end_date, @item_sk, @cost, 'Y');
end
