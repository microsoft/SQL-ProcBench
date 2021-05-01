CREATE PROCEDURE updateItemPrice (@itemSk int, @newPrice decimal(7, 2))
AS
BEGIN
	UPDATE item set i_current_price = @newPrice 
	where i_item_sk = @itemSk
		 and @newPrice < 3*i_wholesale_cost;
END