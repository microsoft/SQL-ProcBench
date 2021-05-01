CREATE PROCEDURE removeItem (item_sk int)
is
begin
	DELETE from item where i_item_sk = item_sk;
END; 