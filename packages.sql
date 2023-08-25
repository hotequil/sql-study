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
END;
/
