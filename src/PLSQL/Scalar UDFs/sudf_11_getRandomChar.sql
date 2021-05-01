CREATE or REPLACE FUNCTION genRandomChar(chars varchar, rand  number)
RETURN CHAR
IS
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
END;
