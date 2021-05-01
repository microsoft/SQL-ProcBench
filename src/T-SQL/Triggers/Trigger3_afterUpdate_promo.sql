CREATE or ALTER TRIGGER promo_update ON promotion
AFTER UPDATE
AS  
	insert into logTable
	select 'promo sk number ' + cast(i.p_promo_sk as varchar(max))+ '  re-activated', getDate() 
	from deleted d, inserted i
	where d.p_promo_sk = i.p_promo_sk
		and d.p_discount_active='N' and i.p_discount_active='Y';

GO 

--invocation query
update promotion set p_discount_active='N' where p_promo_sk>=200 and p_promo_sk<400;