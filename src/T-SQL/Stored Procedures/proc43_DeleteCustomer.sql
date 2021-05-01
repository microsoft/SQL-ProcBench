create or alter procedure deleteCustomer(@user_list UserList READONLY)
as
begin
	set nocount on;
	declare @sk int;
	
	declare custCur cursor static for (select UserSk from @user_list);
	open custCur;
	fetch next from custCur into @sk;
	while(@@fetch_status=0)
	begin
		delete from customer where c_customer_sk = @sk;
		fetch next from custCur into @sk;
	end
	close custCur;
	deallocate custCur;

end
go

--invocation query
CREATE TYPE UserList AS TABLE ( UserSk INT );
go

DECLARE @UL UserList;
INSERT @UL VALUES (5),(44),(72),(81),(126), (230), (467), (876), (1609), (3254), (78574), (435893);

exec dbo.deleteCustomer @UL
go