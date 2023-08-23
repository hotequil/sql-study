SELECT MAX(sal), MIN(sal), AVG(sal), SUM(sal) FROM emp;

SELECT SUBSTR('abcd', 1, 3) FROM dual;

CREATE OR REPLACE FUNCTION get_salary(p_id IN emp.empno%TYPE) RETURN NUMBER IS
    v_salary emp.sal%TYPE := 0;
BEGIN    
    SELECT sal INTO v_salary FROM emp WHERE empno = p_id;
    
    RETURN v_salary;
END get_salary;
/

SELECT empno, get_salary(empno) FROM emp;

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_salary(7782));
END;
/

CREATE OR REPLACE FUNCTION departments_total RETURN NUMBER IS
    v_total NUMBER(8) := 0;
BEGIN
    SELECT COUNT(*) INTO v_total FROM emp;
    
    RETURN v_total;
END;
/

SET SERVEROUTPUT ON
DECLARE
    v_count NUMBER(8);
BEGIN    
    v_count := departments_total;
    
    DBMS_OUTPUT.PUT_LINE('Departments total: ' || v_count);
END;
/

CREATE OR REPLACE FUNCTION calculate_annual_salary(p_salary NUMBER, p_commission NUMBER) RETURN NUMBER IS BEGIN
    RETURN (p_salary + nvl(p_commission, 0)) * 12;
END calculate_annual_salary;
/

SELECT sal, comm, calculate_annual_salary(sal, comm) FROM emp;

SET SERVEROUTPUT ON
DECLARE
    v_annual_salary NUMBER(6);
BEGIN    
    v_annual_salary := calculate_annual_salary(1000, 50);
    
    DBMS_OUTPUT.PUT_LINE('Annual salary: ' || v_annual_salary);
END;
/

CREATE OR REPLACE FUNCTION ordinary(p_number NUMBER) RETURN VARCHAR2 IS BEGIN
    CASE p_number
        WHEN 1 THEN RETURN 'first';
        WHEN 2 THEN RETURN 'second';
        WHEN 3 THEN RETURN 'third';
        WHEN 4 THEN RETURN 'fourth';
        WHEN 5 THEN RETURN 'fifth';
        WHEN 6 THEN RETURN 'sixth';
        WHEN 7 THEN RETURN 'seventh';
        WHEN 8 THEN RETURN 'eighth';
        WHEN 9 THEN RETURN 'nineth';
        ELSE RETURN 'unforeseen';
    END CASE;    
END;
/

SELECT ordinary(2) FROM dual;
SELECT ordinary(8) FROM dual;
SELECT ordinary(10) FROM dual;

SET SERVEROUTPUT ON
BEGIN 
    FOR my_index IN 0..10 LOOP
        DBMS_OUTPUT.PUT_LINE(ordinary(my_index));
    END LOOP;
END;
/
