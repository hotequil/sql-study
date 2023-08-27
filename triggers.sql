ALTER SESSION SET nls_date_format='DD/MM/YY HH24:MI:SS';

CREATE TABLE salaries_audit(
    code NUMBER(6),
    date_time DATE,
    operation VARCHAR2(6),
    new_salary NUMBER(10, 2),
    last_salary NUMBER(10, 2)
);

SELECT * FROM salaries_audit;

TRUNCATE TABLE salaries_audit;

CREATE OR REPLACE PROCEDURE register_salary(
    p_code IN salaries_audit.code%TYPE,
    p_operation IN salaries_audit.operation%TYPE,
    p_new_salary IN salaries_audit.new_salary%TYPE,
    p_last_salary IN salaries_audit.last_salary%TYPE
) AS PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO salaries_audit(code, date_time, operation, new_salary, last_salary) VALUES(p_code, SYSDATE, p_operation, p_new_salary, p_last_salary);
    COMMIT;
END;
/

SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER tr_salarial_changes BEFORE INSERT OR DELETE OR UPDATE OF sal ON emp FOR EACH ROW WHEN (NEW.sal > 1000 OR OLD.sal > 1000)
DECLARE 
    difference NUMBER;
BEGIN
    IF INSERTING OR UPDATING THEN 
        DBMS_OUTPUT.PUT_LINE('New salary: ' || :NEW.sal);
    END IF;    
        
    IF UPDATING OR DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Old salary: ' || :OLD.sal);
    END IF;
    
    IF UPDATING THEN 
        difference := :NEW.sal - :OLD.sal;

        DBMS_OUTPUT.PUT_LINE('Salary difference: ' || difference);
        
        register_salary(:OLD.empno, 'UPDATE', :NEW.sal, :OLD.sal);
    END IF;   
    
    IF INSERTING THEN
        register_salary(:NEW.empno, 'INSERT', :NEW.sal, :OLD.sal);
    END IF;
    
    IF DELETING THEN
        register_salary(:OLD.empno, 'DELETE', :NEW.sal, :OLD.sal);
    END IF;
END;
/

BEGIN
    INSERT INTO emp(empno, ename, sal) VALUES (1000, 'João', 2000);
END;
/

SELECT * FROM emp WHERE empno = 1000;

BEGIN
    UPDATE emp SET sal = sal * 2 WHERE empno = 1000;
END;
/

BEGIN
    DELETE FROM emp WHERE empno = 1000;    
END;
/
