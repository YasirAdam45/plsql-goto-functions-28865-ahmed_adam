-- Tests for B1 - B4
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- B1 fn_annual_salary ---');
    DBMS_OUTPUT.PUT_LINE('500000   -> ' || fn_annual_salary(500000) || ' (expect 6000000)');
    DBMS_OUTPUT.PUT_LINE('NULL     -> ' || NVL(TO_CHAR(fn_annual_salary(NULL)), 'NULL') || ' (expect NULL)');
    BEGIN
        DBMS_OUTPUT.PUT_LINE(fn_annual_salary(-1));
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('-1       -> ' || SQLERRM || ' (expect ORA-20001)');
    END;

    DBMS_OUTPUT.PUT_LINE('--- B2 fn_years_of_service ---');
    DBMS_OUTPUT.PUT_LINE('2015-03-01 -> ' || fn_years_of_service(DATE '2015-03-01'));
    DBMS_OUTPUT.PUT_LINE('today      -> ' || fn_years_of_service(SYSDATE) || ' (expect 0)');
    BEGIN
        DBMS_OUTPUT.PUT_LINE(fn_years_of_service(SYSDATE + 10));
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('future     -> ' || SQLERRM || ' (expect ORA-20002)');
    END;

    DBMS_OUTPUT.PUT_LINE('--- B3 fn_calculate_tax ---');
    DBMS_OUTPUT.PUT_LINE('500000   -> ' || fn_calculate_tax(500000)  || ' (expect 0)');
    DBMS_OUTPUT.PUT_LINE('1000000  -> ' || fn_calculate_tax(1000000) || ' (expect 56000)');
    DBMS_OUTPUT.PUT_LINE('2000000  -> ' || fn_calculate_tax(2000000) || ' (expect 336000)');

    DBMS_OUTPUT.PUT_LINE('--- B4 fn_dept_name ---');
    DBMS_OUTPUT.PUT_LINE('10   -> ' || fn_dept_name(10) || ' (expect Finance)');
    DBMS_OUTPUT.PUT_LINE('99   -> ' || fn_dept_name(99) || ' (expect Unknown)');
    DBMS_OUTPUT.PUT_LINE('NULL -> ' || fn_dept_name(NULL) || ' (expect Unknown)');
END;
/
