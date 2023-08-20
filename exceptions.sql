SET SERVEROUTPUT ON
DECLARE
    value NUMBER := 4;
BEGIN
    DBMS_OUTPUT.PUT_LINE(value / (value - value));
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('You can not divide with zero');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unknown error');
END;
/
