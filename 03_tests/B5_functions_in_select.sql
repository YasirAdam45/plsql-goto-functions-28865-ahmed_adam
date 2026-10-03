-- B5 - Using the functions inside SQL
SET LINESIZE 200
SET PAGESIZE 50
COL employee FORMAT A22
COL department FORMAT A18

SELECT e.emp_id,
       e.first_name || ' ' || e.last_name  AS employee,
       fn_dept_name(e.dept_id)             AS department,
       e.monthly_salary,
       fn_annual_salary(e.monthly_salary)  AS annual_salary,
       fn_years_of_service(e.hire_date)    AS years_service,
       fn_calculate_tax(fn_annual_salary(e.monthly_salary)) AS annual_tax
  FROM employees e
 WHERE e.hire_date <= SYSDATE
 ORDER BY e.emp_id;
