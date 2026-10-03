-- Tests for C1 fn_validate_payroll
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('101 (good)          -> ' || fn_validate_payroll(101));
    DBMS_OUTPUT.PUT_LINE('106 (no dept)       -> ' || fn_validate_payroll(106));
    DBMS_OUTPUT.PUT_LINE('107 (zero salary)   -> ' || fn_validate_payroll(107));
    DBMS_OUTPUT.PUT_LINE('108 (future hire)   -> ' || fn_validate_payroll(108));
    DBMS_OUTPUT.PUT_LINE('999 (not found)     -> ' || fn_validate_payroll(999));
END;
/

SELECT emp_id, fn_validate_payroll(emp_id) AS payroll_status
  FROM employees
 ORDER BY emp_id;
