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

SET SERVEROUTPUT ON
DECLARE
    error_salary EXCEPTION;
BEGIN
    FOR row_emp IN (SELECT empno, ename, sal FROM emp WHERE empno = 7369) LOOP
        IF row_emp.sal < 1000 THEN
            RAISE error_salary;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Code: ' || row_emp.empno);
        DBMS_OUTPUT.PUT_LINE('Name: ' || row_emp.ename);
        DBMS_OUTPUT.PUT_LINE('Salary: ' || row_emp.sal);
    END LOOP;
EXCEPTION
    WHEN error_salary THEN
        UPDATE emp SET sal = 1000 WHERE empno = 7369;
        COMMIT;
END;
/

SET SERVEROUTPUT ON
DECLARE
    my_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(my_error, -2292);
BEGIN
    DELETE FROM dept WHERE deptno = 10;
    COMMIT;
EXCEPTION
    WHEN my_error THEN
        DBMS_OUTPUT.PUT_LINE('Can not delete department');
        ROLLBACK;
END;
/

SET SERVEROUTPUT ON
DECLARE
    value NUMBER := 6;
BEGIN
    DBMS_OUTPUT.PUT_LINE(value / (value - value));
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        RAISE_APPLICATION_ERROR(-20901, 'Math error');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unknown error');
END;
/

BEGIN
    DELETE FROM dept WHERE deptno = 9999;
    
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20902, 'There is no department with this code');
        ROLLBACK;
    END IF;
END;
/
