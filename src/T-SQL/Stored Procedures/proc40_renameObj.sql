CREATE PROCEDURE RenameObject(
    @SchemaName NVARCHAR(MAX),
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
	)
AS
BEGIN
   SET @NewName='newName123';

   DECLARE @RenameCmd NVARCHAR(MAX);
   SET @RenameCmd = 'EXEC sp_rename ''' + 
                          @SchemaName + '.' + @ObjectName + ''', ''' + 
                          @NewName + ''';';

   EXEC @RenameCmd;

END;