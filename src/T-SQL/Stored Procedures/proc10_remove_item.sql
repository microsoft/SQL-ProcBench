CREATE PROCEDURE removeItem (@item_sk int)
AS
BEGIN
	DELETE from item where i_item_sk = @item_sk;
END