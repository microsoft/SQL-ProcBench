CREATE or replace PROCEDURE CreateRandomString (randomString  INOUT VARCHAR(16))
language plpgsql
AS $$
declare
  stringLength INT =16;
  chars VARCHAR(200);
begin 
  chars:= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  randomString := '';
  WHILE LENGTH(randomString) < stringLength loop
    randomString := randomString || genRandomChar(chars, random());
  END LOOP;
END; $$

--ivocation query
call CreateRandomString('')



