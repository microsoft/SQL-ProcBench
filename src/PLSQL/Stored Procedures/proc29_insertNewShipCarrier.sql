create or replace procedure newShippingCarrier(typ char, code char,  nam char,
										contract char)
is
	randomString varchar(16);
	ske int;
	ide char(16);
begin
	select max(sm_ship_mode_sk)+1 into ske from ship_mode;
	randomString:='';
	CreateRandomString (randomString);
	ide := randomString;

	insert into ship_mode (sm_ship_mode_sk, sm_ship_mode_id, sm_type, sm_code, sm_carrier, sm_contract)
			values (ske, ide, typ, code, nam, contract);

end; 

--calling query
call newShippingCarrier ('FORTNIGHT', 'SEA', 'SHIPCo', '83hdjk0hf8j')