--Generate a random integer between given lower and upper bounds Called from sudf_11_genRandomChar

CREATE FUNCTION genRandomInt
(
  @lower  INT,
  @upper  INT,
  @rand   FLOAT
)
RETURNS INT
AS
BEGIN
  DECLARE @result INT;
  DECLARE @range int = @upper - @lower + 1;
  SET @result = FLOOR(@rand * @range + @lower);
  RETURN @result;
END
GO