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

CREATE TABLE user_errors(
    user_error VARCHAR2(40),
    created_date DATE,
    code NUMBER,
    message VARCHAR2(100)
);

SELECT * FROM user_errors;

SET SERVEROUTPUT ON
DECLARE
    code user_errors.code%TYPE;
    message user_errors.message%TYPE;
    value NUMBER := 2;
BEGIN
    DBMS_OUTPUT.PUT_LINE(value / (value - value));
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        code := SQLCODE;
        message := SUBSTR(SQLERRM, 1, 100);
        
        INSERT INTO user_errors VALUES (USER, SYSDATE, code, message);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unknown error');
END;
/
