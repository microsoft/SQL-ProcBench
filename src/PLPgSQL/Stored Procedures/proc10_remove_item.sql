CREATE PROCEDURE removeItem (item_sk int)
language plpgsql
as $$
begin
	DELETE from item where i_item_sk = item_sk;
END; $$