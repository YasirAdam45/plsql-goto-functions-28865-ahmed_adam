-- C1 - Payroll Validator (combines GOTO, functions and exception handling)
-- Returns 'VALID' or 'INVALID: <reason>'. Depends on B3 and B4.
-- GOTO is used so every failed check jumps to one single exit point.
CREATE OR REPLACE FUNCTION fn_validate_payroll (p_emp_id IN NUMBER)
RETURN VARCHAR2
IS
    v_salary employees.monthly_salary%TYPE;
    v_hire   employees.hire_date%TYPE;
    v_dept   employees.dept_id%TYPE;
    v_msg    VARCHAR2(200);
BEGIN
    SELECT monthly_salary, hire_date, dept_id
      INTO v_salary, v_hire, v_dept
      FROM employees
     WHERE emp_id = p_emp_id;

    -- Check 1: salary must exist and be positive
    IF v_salary IS NULL OR v_salary <= 0 THEN
        v_msg := 'INVALID: salary must be greater than zero.';
        GOTO done;
    END IF;

    -- Check 2: hire date cannot be in the future
    IF v_hire > SYSDATE THEN
        v_msg := 'INVALID: hire date is in the future.';
        GOTO done;
    END IF;

    -- Check 3: employee must belong to an existing department
    IF fn_dept_name(v_dept) = 'Unknown' THEN
        v_msg := 'INVALID: employee has no valid department.';
        GOTO done;
    END IF;

    -- Check 4: calculated tax must not exceed the annual salary
    IF fn_calculate_tax(v_salary * 12) > v_salary * 12 THEN
        v_msg := 'INVALID: tax exceeds annual salary.';
        GOTO done;
    END IF;

    v_msg := 'VALID';

    <<done>>
    RETURN v_msg;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'INVALID: employee ' || p_emp_id || ' not found.';
    WHEN OTHERS THEN
        RETURN 'INVALID: unexpected error - ' || SQLERRM;
END fn_validate_payroll;
/
SHOW ERRORS
