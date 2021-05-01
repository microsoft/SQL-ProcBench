CREATE TRIGGER promo_update 
AFTER UPDATE
ON promotion
FOR EACH ROW
BEGIN
    
    if(:old.p_discount_active='N' and :new.p_discount_active='Y') then
        insert into logTable values( 'promo sk number ' || :old.p_promo_sk || '  re-activated', current_timestamp);
    end if;
END; 

--invocation query
update promotion set p_discount_active='Y' where p_promo_sk>=200 and p_promo_sk<400
