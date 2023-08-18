CREATE TABLE person(
    name VARCHAR2(18)
);

SELECT * FROM person;

INSERT INTO person VALUES('Campo com 18 bytes');

SET SERVEROUTPUT ON
DECLARE 
    v_name person.name%TYPE;
BEGIN
    SELECT name INTO v_name FROM person;
    DBMS_OUTPUT.PUT_LINE('Name is ' || v_name);
END;

TRUNCATE TABLE person;

ALTER TABLE person MODIFY name VARCHAR2(30);

INSERT INTO person VALUES('Tamanho alterado para 30 bytes');

SET SERVEROUTPUT ON
DECLARE
    v_name person.name%TYPE;
    v_size NUMBER(4);
BEGIN
    SELECT name, LENGTH(name) INTO v_name, v_size FROM person;
    
    IF TO_CHAR(SYSDATE, 'YYYY') = 2023 AND v_size > 25 THEN
        DBMS_OUTPUT.PUT_LINE('Name is ' || v_name || '. Size is ' || v_size || '.');
    ELSIF TO_CHAR(SYSDATE, 'YYYY') = 2022 OR v_size > 20 THEN
        DBMS_OUTPUT.PUT_LINE('Bigger than 20 chars.');
    ELSIF v_size > 15 THEN
        DBMS_OUTPUT.PUT_LINE('Bigger than 15 chars.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Small size in variable.');
    END IF;    
END;

UPDATE person SET name = 'Tamanho alterado para 30 bytes';
UPDATE person SET name = '123456789012345678901';
UPDATE person SET name = '1234567890123456';
UPDATE person SET name = '12345';

DECLARE
    v_counter NUMBER(2) := 1;
BEGIN
    LOOP     
        INSERT INTO person VALUES('Person ' || v_counter);
    
        v_counter := v_counter + 1;    
    EXIT WHEN v_counter > 10;
    END LOOP;
END;

BEGIN
    FOR loop_index IN 1..10 LOOP
        INSERT INTO person VALUES('Person ' || loop_index);
    END LOOP;
END;

DECLARE
    v_counter NUMBER(2) := 1;
BEGIN
    WHILE v_counter <= 10 LOOP
        INSERT INTO person VALUES('New person ' || v_counter);
        
        v_counter := v_counter + 1;
    END LOOP;    
END;

SET SERVEROUTPUT ON
BEGIN
    FOR parent_index IN 1..4 LOOP
        FOR child_index IN 1..8 LOOP
            DBMS_OUTPUT.PUT_LINE(parent_index || ' | ' || child_index);    
        END LOOP;
    END LOOP;
END;

SET SERVEROUTPUT ON
DECLARE
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_job emp.job%TYPE;
    v_mgr emp.mgr%TYPE;
    v_hiredate emp.hiredate%TYPE;
    v_sal emp.sal%TYPE;
    v_comm emp.comm%TYPE;
    v_deptno emp.deptno%TYPE;
BEGIN
    SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno 
    INTO v_empno, v_ename, v_job, v_mgr, v_hiredate, v_sal, v_comm, v_deptno
    FROM emp WHERE empno = 7839;
    
    DBMS_OUTPUT.PUT_LINE('Code: ' || v_empno);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('Job: ' || v_job);
    DBMS_OUTPUT.PUT_LINE('Manager: ' || v_mgr);
    DBMS_OUTPUT.PUT_LINE('Date: ' || v_hiredate);
    DBMS_OUTPUT.PUT_LINE('Sallary: ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('Commission: ' || v_comm);
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_deptno);
END;

SET SERVEROUTPUT ON
DECLARE
    row_emp emp%ROWTYPE;    
BEGIN
    SELECT * INTO row_emp FROM emp WHERE empno = 7839;
    
    DBMS_OUTPUT.PUT_LINE('Code: ' || row_emp.empno);
    DBMS_OUTPUT.PUT_LINE('Name: ' || row_emp.ename);
    DBMS_OUTPUT.PUT_LINE('Job: ' || row_emp.job);
    DBMS_OUTPUT.PUT_LINE('Manager: ' || row_emp.mgr);
    DBMS_OUTPUT.PUT_LINE('Date: ' || row_emp.hiredate);
    DBMS_OUTPUT.PUT_LINE('Sallary: ' || row_emp.sal);
    DBMS_OUTPUT.PUT_LINE('Commission: ' || row_emp.comm);
    DBMS_OUTPUT.PUT_LINE('Department: ' || row_emp.deptno);
END;

SET SERVEROUTPUT ON
BEGIN
    DELETE FROM emp WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('Deleted rows quantity: ' || SQL%ROWCOUNT);
    
    IF SQL%ISOPEN = true THEN
        DBMS_OUTPUT.PUT_LINE('Is open: yes');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Is open: no');
    END IF;
    
    IF SQL%FOUND = true THEN
        DBMS_OUTPUT.PUT_LINE('Found: yes');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Found: no');
    END IF;

    IF SQL%NOTFOUND = true THEN
        DBMS_OUTPUT.PUT_LINE('Not found: yes');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not found: no');
    END IF;
    
    ROLLBACK;
END;

SET SERVEROUTPUT ON
DECLARE
    row_emp emp%ROWTYPE;
    
    CURSOR cursor_emp IS SELECT deptno, SUM(sal) FROM emp GROUP BY deptno;
BEGIN
    OPEN cursor_emp;
    
    LOOP
        FETCH cursor_emp INTO row_emp.deptno, row_emp.sal;

        EXIT WHEN cursor_emp%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE('Department: ' || row_emp.deptno);
        DBMS_OUTPUT.PUT_LINE('Salary: ' || row_emp.sal);
    END LOOP;
    
    CLOSE cursor_emp;
END;

SET SERVEROUTPUT ON
DECLARE
    CURSOR cursor_emp IS SELECT deptno, SUM(sal) sum FROM emp GROUP BY deptno;
BEGIN
    FOR row_emp IN cursor_emp LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || row_emp.deptno);
        DBMS_OUTPUT.PUT_LINE('Salary: ' || row_emp.sum);
    END LOOP;
END;

SET SERVEROUTPUT ON
BEGIN
    FOR row_emp IN (SELECT deptno, SUM(sal) sum FROM emp GROUP BY deptno) LOOP
        DBMS_OUTPUT.PUT_LINE('Department: '|| row_emp.deptno);
        DBMS_OUTPUT.PUT_LINE('Salary: ' || row_emp.sum);
    END LOOP;
END;

SET SERVEROUTPUT ON
DECLARE
    row_emp emp%ROWTYPE;
    
    CURSOR cursor_emp IS SELECT empno, sal FROM emp FOR UPDATE;
BEGIN
    OPEN cursor_emp;
    
    LOOP
        FETCH cursor_emp INTO row_emp.empno, row_emp.sal;
        
        EXIT WHEN cursor_emp%NOTFOUND;
        
        UPDATE emp SET sal = sal * 1.5 WHERE CURRENT OF cursor_emp;     
    END LOOP;
    
    CLOSE cursor_emp;
END;

SELECT DISTINCT object_type FROM user_objects;

SELECT DISTINCT object_type FROM all_objects;
