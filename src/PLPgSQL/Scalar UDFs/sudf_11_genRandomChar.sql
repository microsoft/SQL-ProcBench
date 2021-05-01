--Pick a random character from a given list of characters. This is called from stored procedure proc_24_CreateRandomString

CREATE or REPLACE FUNCTION genRandomChar(chars varchar, rand float )
RETURNS CHAR
language plpgsql
as $$
declare
    rslt CHAR(1) := NULL;
    resultIndex INT := NULL;
BEGIN
    IF chars IS NULL then
        rslt := NULL;
    ELSIF LENGTH(chars) = 0 then
        rslt := NULL;
    ELSE
        resultIndex := genRandomInt(1, LENGTH(chars), rand);
        rslt := SUBSTR(chars, resultIndex, 1);
    END IF;
    RETURN rslt;
END; $$