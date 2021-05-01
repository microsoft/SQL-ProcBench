CREATE or alter PROCEDURE CreateRandomString
  @randomString VARCHAR(16) OUTPUT
AS BEGIN 
  SET NOCOUNT ON;

  DECLARE @stringLength INT =16;
  DECLARE @chars VARCHAR(200) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  SET @randomString = '';

  WHILE LEN(@randomString) < @stringLength
  BEGIN
    SET @randomString = @randomString + dbo.genRandomChar(@chars, RAND());
  END
END
go

--ivocation query
declare @randomString VARCHAR(16);
EXEC [dbo].[CreateRandomString] @randomString OUTPUT;
SELECT @randomString AS [Random String];
go



