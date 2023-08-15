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
