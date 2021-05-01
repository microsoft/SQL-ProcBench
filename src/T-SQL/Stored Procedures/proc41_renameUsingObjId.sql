CREATE PROCEDURE RenameObjectUsingObjectId(
    @ObjectId INT,
    @NewName NVARCHAR(MAX) = NULL OUTPUT
	)
AS
BEGIN
	set nocount on;

   DECLARE @SchemaName NVARCHAR(MAX);
   DECLARE @ObjectName NVARCHAR(MAX);
   
   SELECT @SchemaName = QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), @ObjectName = QUOTENAME(OBJECT_NAME(@ObjectId));
   
   EXEC dbo.RenameObject @SchemaName,@ObjectName, @NewName OUTPUT;
END;
GO