SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER tr_salarial_changes BEFORE INSERT OR DELETE OR UPDATE ON emp FOR EACH ROW
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
