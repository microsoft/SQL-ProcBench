CREATE or REPLACE FUNCTION genRandomInt
(
  lower  INT,
  upper  INT,
  rand   FLOAT
)
RETURN INT
IS
    result INT;
    range int;
BEGIN
  range := upper - lower + 1;
  result := FLOOR(rand * range + lower);
  RETURN result;
END;