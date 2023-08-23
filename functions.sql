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
