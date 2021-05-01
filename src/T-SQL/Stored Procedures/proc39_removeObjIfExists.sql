CREATE PROCEDURE RemoveObjectIfExists(
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
	)
AS
BEGIN
	set nocount on;
	if exists (select * from sys.objects where name = @ObjectName)
		EXEC dbo.RemoveObject @ObjectName = @ObjectName, @NewName = @NewName OUT, @IfExists = 1;
END;
GO
