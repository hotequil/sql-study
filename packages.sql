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
    TYPE RegEmp IS RECORD(v_empno emp.empno%TYPE, v_sal emp.sal%TYPE);
    TYPE RegDept IS RECORD(v_deptno dept.deptno%TYPE, v_loc dept.deptno%TYPE);
    CURSOR c_salary RETURN RegEmp;
    invalid_salary EXCEPTION;
    FUNCTION fn_valid_salary(p_salary emp.sal%TYPE) RETURN BOOLEAN;
    FUNCTION fn_hire(p_name emp.ename%TYPE, p_job emp.job%TYPE, p_mgr emp.mgr%TYPE, p_salary emp.sal%TYPE, p_commission emp.comm%TYPE, p_deptno emp.deptno%TYPE) RETURN INT;
    PROCEDURE sp_fire(p_empno emp.empno%TYPE);
    FUNCTION fn_get_salary (p_id IN emp.empno%TYPE) RETURN emp.sal%TYPE;
    PROCEDURE sp_readjustment (p_id IN emp.empno%TYPE, p_percentage IN NUMBER DEFAULT 20);
    FUNCTION fn_bigger_salaries(p_quantity INT) RETURN RegEmp;
END pkg_hr;
/

DESC pkg_hr;

CREATE OR REPLACE PACKAGE BODY pkg_hr AS 
    CURSOR c_salary RETURN RegEmp IS SELECT empno, sal FROM emp ORDER BY sal DESC;
    
    FUNCTION fn_hire(p_name emp.ename%TYPE, p_job emp.job%TYPE, p_mgr emp.mgr%TYPE, p_salary emp.sal%TYPE, p_commission emp.comm%TYPE, p_deptno emp.deptno%TYPE) RETURN INT IS
        v_id INT;
    BEGIN 
        SELECT MAX(empno) + 1 INTO v_id FROM emp;
        
        INSERT INTO emp(empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES (v_id, p_name, p_job, p_mgr, SYSDATE, p_salary, p_commission, p_deptno);
        
        COMMIT;
        
        RETURN v_id;
    END;
    
    PROCEDURE sp_fire(p_empno emp.empno%TYPE) IS BEGIN 
        DELETE FROM emp WHERE empno = p_empno;
    END sp_fire;

    FUNCTION fn_valid_salary(p_salary emp.sal%TYPE) RETURN BOOLEAN IS
        v_min_salary emp.sal%TYPE;
        v_max_salary emp.sal%TYPE;
    BEGIN
        SELECT MIN(sal), MAX(sal) INTO v_min_salary, v_max_salary FROM emp;
        
        RETURN (p_salary >= v_min_salary) AND (p_salary <= v_max_salary);
    END;

    FUNCTION fn_get_salary(p_id IN emp.empno%TYPE) RETURN emp.sal%TYPE IS
        v_salary emp.sal%TYPE := 0;
    BEGIN    
        SELECT sal INTO v_salary FROM emp WHERE empno = p_id;
        
        RETURN v_salary;
    END fn_get_salary;
    
    PROCEDURE sp_readjustment(p_id IN emp.empno%TYPE, p_percentage IN NUMBER DEFAULT 20) IS 
        v_salary emp.sal%TYPE;
        v_next_salary emp.sal%TYPE;
    BEGIN   
        SELECT sal INTO v_salary FROM emp WHERE empno = p_id;
        
        v_next_salary := v_salary + (v_salary * (p_percentage / 100));
        
        IF fn_valid_salary(v_next_salary) THEN
            UPDATE emp SET sal = v_next_salary WHERE empno = p_id;
            COMMIT;
        ELSE
            RAISE invalid_salary;
        END IF;
    END sp_readjustment;
    
    FUNCTION fn_bigger_salaries(p_quantity INT) RETURN RegEmp IS 
        emp_row RegEmp;
    BEGIN
        OPEN c_salary;
        
        FOR index_value IN 1..p_quantity LOOP
            FETCH c_salary INTO emp_row;
        END LOOP;
        
        CLOSE c_salary;
        
        RETURN emp_row;
    END fn_bigger_salaries;    
END pkg_hr;
/

EXEC pkg_hr.sp_readjustment(7900, 10);

SET SERVEROUTPUT ON
DECLARE
    v_id emp.empno%TYPE;
BEGIN
    v_id := pkg_hr.fn_hire('Tim Maia', 'Manager', 7839, 9000, NULL, 10);

    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id);
    DBMS_OUTPUT.PUT_LINE(pkg_hr.fn_get_salary(7900));    
    
    pkg_hr.sp_fire(7935);
END;
/

SELECT pkg_hr.fn_get_salary(7900) FROM dual;
