-- A2 - Salary Review (uses GOTO)
-- Requires: fn_annual_salary (B1). Run 02_functions first.
SET SERVEROUTPUT ON
DECLARE
    v_emp_id  employees.emp_id%TYPE := 101;   -- try 101, 102, 103, 104
    v_name    VARCHAR2(100);
    v_salary  employees.monthly_salary%TYPE;
    v_annual  NUMBER;
BEGIN
    SELECT first_name || ' ' || last_name, monthly_salary
      INTO v_name, v_salary
      FROM employees
     WHERE emp_id = v_emp_id;

    v_annual := fn_annual_salary(v_salary);
    DBMS_OUTPUT.PUT_LINE('Employee : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Monthly  : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Annual   : ' || v_annual);

    IF v_salary >= 1000000 THEN
        GOTO senior_band;
    ELSIF v_salary >= 500000 THEN
        GOTO mid_band;
    ELSE
        GOTO entry_band;
    END IF;

    <<senior_band>>
    DBMS_OUTPUT.PUT_LINE('Review   : Senior band - 3% adjustment, leadership review.');
    GOTO end_review;

    <<mid_band>>
    DBMS_OUTPUT.PUT_LINE('Review   : Mid band - 6% adjustment.');
    GOTO end_review;

    <<entry_band>>
    DBMS_OUTPUT.PUT_LINE('Review   : Entry band - 10% adjustment, training plan.');

    <<end_review>>
    DBMS_OUTPUT.PUT_LINE('Salary review complete.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || v_emp_id || ' not found.');
END;
/
