CREATE or alter PROCEDURE updateWebURL(@oldUrl varchar(100), @newUrl varchar(100))
AS
BEGIN
	set nocount on;
	
	UPDATE web_page
	set wp_url = @newUrl
	where wp_url = @oldUrl;
END
go

--execution query
exec updateWebURL 'http://www.bar.com', 'http://www.foo.com'
go