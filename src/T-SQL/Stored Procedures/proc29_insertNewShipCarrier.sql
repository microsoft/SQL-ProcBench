create or alter procedure newShippingCarrier(@type char(30), @code char(10),  @name char(20),
										@contract char(20))
as
begin
	set nocount on;

	declare @randomString char(16);
	declare @sk int;
	declare @id char(16);

	set @sk = (select max(sm_ship_mode_sk)+1 from ship_mode );
	
	EXEC dbo.CreateRandomString @randomString OUTPUT;
	set @id = @randomString;

	insert into ship_mode (sm_ship_mode_sk, sm_ship_mode_id, sm_type, sm_code, sm_carrier, sm_contract)
			values (@sk, @id, @type, @code, @name, @contract);

end

--calling query
exec dbo.newShippingCarrier 'FORTNIGHT', 'SEA', 'SHIPCo', '83hdjk0hf8j'
go

