SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE to_sqrt(the_number IN NUMBER := 0) IS BEGIN
    DBMS_OUTPUT.PUT_LINE(the_number * the_number);
END to_sqrt;
/

EXECUTE to_sqrt(4);
EXECUTE to_sqrt(6);
EXECUTE to_sqrt(8);

CREATE OR REPLACE PROCEDURE readjustment (p_code_emp IN emp.empno%TYPE, p_percentage IN NUMBER DEFAULT 20) IS 
BEGIN
    UPDATE emp SET sal = sal + (sal * (p_percentage / 100)) WHERE empno = p_code_emp;
    COMMIT;
END readjustment;
/

SELECT empno, sal FROM emp WHERE empno = 7839;

EXECUTE readjustment(7839, 10);
EXECUTE readjustment(7839);

CREATE OR REPLACE PROCEDURE get_emp_data (p_id IN emp.empno%TYPE, p_name OUT emp.ename%TYPE, p_salary OUT emp.sal%TYPE) IS
BEGIN
    SELECT ename, sal INTO p_name, p_salary FROM emp WHERE empno = p_id;
END get_emp_data;
/

SET SERVEROUTPUT ON
DECLARE 
    v_name emp.ename%TYPE;
    v_salary emp.sal%TYPE;
BEGIN
    get_emp_data(7839, v_name, v_salary);
    
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
END;
/

CREATE OR REPLACE PROCEDURE format_phone (p_phone IN OUT VARCHAR2) IS 
BEGIN
    p_phone := '(' || SUBSTR(p_phone, 0, 2) || ') ' || SUBSTR(p_phone, 3, 5) || '-' || SUBSTR(p_phone, 8);
END format_phone;
/

SET SERVEROUTPUT ON
DECLARE
    v_phone VARCHAR2(20) := '47987654321';
BEGIN
    format_phone(v_phone);

    DBMS_OUTPUT.PUT_LINE(v_phone);
END;
/

SHOW ERRORS;

CREATE OR REPLACE PROCEDURE create_department (
    p_id IN dept.deptno%TYPE DEFAULT '50',
    p_name IN dept.dname%TYPE DEFAULT 'IT',
    p_location IN dept.loc%TYPE DEFAULT 'SC'
) IS 
BEGIN
    INSERT INTO dept(deptno, dname, loc) VALUES(p_id, p_name, p_location);
    COMMIT;
END create_department;
/

BEGIN 
    create_department;
END;
/

BEGIN
    create_department('55', 'HR', 'RS');
END;
/

BEGIN 
    create_department(p_location => 'PR', p_id => '60', p_name => 'MKT');
END;
/

BEGIN 
    create_department('65', p_location => 'SC', p_name => 'CLV');
END;
/

SELECT * FROM dept WHERE deptno >= '50';
