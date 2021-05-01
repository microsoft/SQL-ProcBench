CREATE or ALTER PROCEDURE RemoveObject(
    @objName nvarchar(max),
	@newName NVARCHAR(MAX)=NULL OUTPUT,
	@IfExists int = 0)
AS
BEGIN
  DECLARE @ObjectId INT;
  SELECT @ObjectId = OBJECT_ID(@objName);
  
  IF(@ObjectId IS NULL)
  BEGIN
    IF(@IfExists = 1) RETURN;
    RAISERROR('%s does not exist!',16,10,@objName);
  END;

  EXEC dbo.RenameObjectUsingObjectId @ObjectId, @NewName = @NewName OUTPUT;
END;
GO