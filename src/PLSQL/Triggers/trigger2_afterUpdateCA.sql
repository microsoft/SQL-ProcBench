CREATE OR replace TRIGGER ca_update
AFTER UPDATE
ON customer_address
FOR EACH ROW
DECLARE
    adr_sk int; adr_sk_varchar varchar(32767); 
BEGIN
        adr_sk:= :old.ca_address_sk;
        adr_sk_varchar := TO_CHAR(adr_sk);
        if(:old.ca_country != :new.ca_country)then
            insert into logTable values ('address' || adr_sk_varchar || 'changed to different country', current_timestamp  );
        elsif (:old.ca_state != :new.ca_state) then
            insert into logTable values ('address' || adr_sk_varchar || 'changed to different state', current_timestamp  );
        elsif (:old.ca_city != :new.ca_city) then
            insert into logTable values ('address' || adr_sk_varchar || 'changed to different city', current_timestamp  );
        end if;
END;



--invocation query
update customer_address  
set ca_country=
(case 
when (ca_address_sk<=5) then 'India'
when (ca_address_sk>5 and ca_address_sk<=10) then 'NewZealand'
when (ca_address_sk>10 and ca_address_sk<=15) then 'France'
end
) 
where ca_address_sk<=15;
