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

SET SERVEROUTPUT ON
DECLARE
    my_error EXCEPTION;
    row_emp emp%ROWTYPE;
    CURSOR cursor_emp IS SELECT empno, ename FROM emp WHERE empno = 9999;
BEGIN
    OPEN cursor_emp;
    
    LOOP
        FETCH cursor_emp INTO row_emp.empno, row_emp.ename;
        
        IF cursor_emp%NOTFOUND THEN
            RAISE my_error;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Code: ' || row_emp.empno);
        DBMS_OUTPUT.PUT_LINE('Name: ' || row_emp.ename);
        
        EXIT WHEN cursor_emp%NOTFOUND;
    END LOOP;
    
    CLOSE cursor_emp;
EXCEPTION
    WHEN my_error THEN
        DBMS_OUTPUT.PUT_LINE('Code not registred');
        ROLLBACK;
END;
/
