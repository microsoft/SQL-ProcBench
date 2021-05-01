CREATE or replace PROCEDURE updateItemPrice (itemSk int, newPrice number)
is
BEGIN
	UPDATE item set i_current_price = newPrice 
	where i_item_sk = itemSk
		 and newPrice < 3*i_wholesale_cost;
END; 