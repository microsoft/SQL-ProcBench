create or replace procedure newShippingCarrier(typ char(30), code char(10),  nam char(20),
										contract char(20))
language plpgsql
as $$
declare
	randomString varchar(16);
	sk int;
	ide char(16);
begin
	sk := (select max(sm_ship_mode_sk)+1 from ship_mode );
	randomString:='';
	call CreateRandomString (randomString);
	ide := randomString;

	insert into ship_mode (sm_ship_mode_sk, sm_ship_mode_id, sm_type, sm_code, sm_carrier, sm_contract)
			values (sk, ide, typ, code, nam, contract);

end; $$

--calling query
call newShippingCarrier ('FORTNIGHT', 'SEA', 'SHIPCo', '83hdjk0hf8j')