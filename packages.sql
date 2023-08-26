CREATE OR REPLACE PACKAGE college AS
    c_name CONSTANT VARCHAR2(4) := 'FIAP';
    c_phone CONSTANT VARCHAR2(14) := '(11) 3333-3333';
    c_rating CONSTANT NUMBER(2) := 10;
END college;
/

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE(college.c_name);
    DBMS_OUTPUT.PUT_LINE(college.c_phone);
    DBMS_OUTPUT.PUT_LINE(college.c_rating);
    DBMS_OUTPUT.PUT_LINE(college.c_rating ** 2);
END;
/

CREATE OR REPLACE PACKAGE pkg_hr AS 
    FUNCTION fn_get_salary (p_id IN emp.empno%TYPE) RETURN emp.sal%TYPE;
    PROCEDURE sp_readjustment (p_id IN emp.empno%TYPE, p_percentage IN NUMBER DEFAULT 20);
END pkg_hr;
/

DESC pkg_hr;

CREATE OR REPLACE PACKAGE BODY pkg_hr AS 
    FUNCTION fn_get_salary(p_id IN emp.empno%TYPE) RETURN emp.sal%TYPE IS
        v_salary emp.sal%TYPE := 0;
    BEGIN    
        SELECT sal INTO v_salary FROM emp WHERE empno = p_id;
        
        RETURN v_salary;
    END fn_get_salary;
    
    PROCEDURE sp_readjustment(p_id IN emp.empno%TYPE, p_percentage IN NUMBER DEFAULT 20) IS BEGIN
        UPDATE emp SET sal = sal + (sal * (p_percentage / 100)) WHERE empno = p_id;
        COMMIT;
    END sp_readjustment;
END pkg_hr;
/

EXEC pkg_hr.sp_readjustment(7900, 10);

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE(pkg_hr.fn_get_salary(7900));
END;
/
