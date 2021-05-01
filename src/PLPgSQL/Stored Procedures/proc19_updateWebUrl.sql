CREATE PROCEDURE updateWebURL(oldUrl varchar(100), newUrl varchar(100))
language plpgsql
as $$
declare
BEGIN
	
	UPDATE web_page
	set wp_url = newUrl
	where wp_url = oldUrl;
END; $$
