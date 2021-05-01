--check if multiple large stores(>250 employees) are managed by the same person.

CREATE OR REPLACE FUNCTION sameManagerForLargeStores() RETURNS BOOL AS
$$
DECLARE
  manag TEXT;
  allManag TEXT;
  c1 TEXT;
BEGIN
  allManag := '';

  FOR c1 IN (SELECT s_manager FROM STORE where s_number_employees>250) LOOP
    allManag := allManag || c1 || ', ';
  END LOOP;

  RETURN NOT isListDistinct(allManag, ',');
END
$$ LANGUAGE PLPGSQL;