--Generate a random integer between given lower and upper bounds Called from sudf_11_genRandomChar

CREATE or REPLACE FUNCTION genRandomInt
(
  lower  INT,
  upper  INT,
  rand   FLOAT
)
RETURNS INT
language plpgsql
as $$
declare
    result INT;
    range int;
BEGIN
  range := upper - lower + 1;
  result := FLOOR(rand * range + lower);
  RETURN result;
END; $$

