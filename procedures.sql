SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE to_sqrt(the_number IN NUMBER := 0) IS BEGIN
    DBMS_OUTPUT.PUT_LINE(the_number * the_number);
END to_sqrt;
/

EXECUTE to_sqrt(4);
EXECUTE to_sqrt(6);
EXECUTE to_sqrt(8);
