CREATE or replace PROCEDURE updateWebURL(oldUrl varchar, newUrl varchar)
is
BEGIN	
	UPDATE web_page
	set wp_url = newUrl
	where wp_url = oldUrl;
END; 
