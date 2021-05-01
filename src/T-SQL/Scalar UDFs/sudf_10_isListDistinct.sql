-- Check if a given list of varchars is distinct. Called from sudf_14_sameManager

CREATE or alter FUNCTION isListDistinct(@List VARCHAR(MAX), @Delim CHAR)
RETURNS
BIT
AS
BEGIN
    DECLARE @Part VARCHAR(MAX), @Pos INT
    SET @List = LTRIM(RTRIM(@List)) + @Delim
    SET @Pos = CHARINDEX(@Delim, @List, 1)
    WHILE (@Pos > 0)
    BEGIN
        SET @Part = LTRIM(RTRIM(LEFT(@List, @Pos)))
        SET @list = SUBSTRING(@list, @pos+1, LEN(@list))
        IF (CHARINDEX(@Part, @List, 1) != 0)
			RETURN 0;

        SET @Pos = CHARINDEX(@Delim, @List, 1)
    END

    RETURN 1;
END