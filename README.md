# PL/SQL GOTO Statements and Functions

**Student:** Ahmed Adam Yasir   |  **Student ID:** 28865
**Course:** Database Development with PL/SQL (INSY 8311)   
**Assignment:** Individual Assignment III  

---

## 1. Overview
This project practises four things in Oracle PL/SQL:
- **GOTO statements** (labels, legal and illegal jumps)
- **Stored functions** (parameters, return values, validation)
- **Exception handling** (`NO_DATA_FOUND`, `RAISE_APPLICATION_ERROR`)
- **Using functions inside SQL** (`SELECT` statements)

Everything runs on two tables: `departments` and `employees`.

## 2. Repository Structure
```
plsql-goto-functions-28865-ahmed/
├── README.md
├── .gitignore
├── 00_setup/
│   └── create_tables.sql
├── 01_goto/
│   ├── A1_number_classifier.sql
│   ├── A2_salary_review.sql
│   ├── A3_illegal_goto.sql
│   └── A4_rewrite_no_goto.sql
├── 02_functions/
│   ├── B1_fn_annual_salary.sql
│   ├── B2_fn_years_of_service.sql
│   ├── B3_fn_calculate_tax.sql
│   ├── B4_fn_dept_name.sql
│   └── C1_fn_validate_payroll.sql
├── 03_tests/
│   ├── B5_functions_in_select.sql
│   ├── test_functions.sql
│   └── test_validate_payroll.sql
├── screenshots/
│   ├── A1_output.png
│   ├── A2_output.png
│   ├── A3_error_and_fix.png
│   ├── A4_output.png
│   ├── B5_select_output.png
│   └── C1_output.png
└── docs/
    └── REFLECTION.md
```

## 3. Requirements
- Oracle Database (XE 18c/21c or later)
- Oracle SQL Developer 
  

## 4. How to Run
Run the files **in this order** (the GOTO programs call the functions, and the functions need the tables):

1. `00_setup/create_tables.sql`
2. `02_functions/B1_fn_annual_salary.sql`, then `B2`, `B3`, `B4`, `C1`
3. `01_goto/A1_number_classifier.sql`, then `A2`, `A3`, `A4`
4. `03_tests/test_functions.sql`, `B5_functions_in_select.sql`, `test_validate_payroll.sql`
5. Check the output against the expected results below.

## 5. Database Design
**departments**: `dept_id` (PK), `dept_name`
**employees**: `emp_id` (PK), `first_name`, `last_name`, `hire_date`, `monthly_salary`, `dept_id` (FK to departments)

Sample data: employees 101-105 are valid. Employees 106 (no department), 107 (zero salary) and 108 (future hire date) are **deliberately invalid** to test the payroll validator.

---

## 6. Part A: GOTO Statements

### A1: Number Classifier
`01_goto/A1_number_classifier.sql`
Classifies a number as positive, negative or zero, then even or odd, using `GOTO` and labels.
**Expected (7):** `Sign: Positive`, `Parity: Odd`.

<img width="2518" height="1044" alt="A1_output" src="https://github.com/user-attachments/assets/d91bc969-3dbb-43c6-91c0-b48bea5301a9" />


### A2: Salary Review
`01_goto/A2_salary_review.sql`
Reads an employee, calculates the annual salary with `fn_annual_salary`, then uses `GOTO` to jump to a salary band (Senior / Mid / Entry).
**Expected (emp 101):** Annual `18000000`, then `Senior band`.

<img width="2512" height="908" alt="A2_output" src="https://github.com/user-attachments/assets/8ab41f88-9696-4b34-a57c-bebd4e4f9c49" />


### A3: Illegal GOTO and Fix
`01_goto/A3_illegal_goto.sql`
- **Illegal:** jumping *into* an `IF` block raises `PLS-00375: illegal GOTO statement; this label is not within the scope of the GOTO statement`.
- **Fix:** put the label in the same or an enclosing block. Jumping *out* of a block is allowed.

<img width="2521" height="1040" alt="A3_error_and_fix" src="https://github.com/user-attachments/assets/2b14602a-9b30-4b6b-a480-0646327cd92e" />


### A4: Rewrite Without GOTO
`01_goto/A4_rewrite_no_goto.sql`
Same logic as A2 using `IF / ELSIF / ELSE`. The output is identical, and the code is shorter and easier to read.

<img width="2551" height="865" alt="A4_output" src="https://github.com/user-attachments/assets/1ec49340-376d-4f3f-bf23-32874bd2cc85" />


---

## 7. Part B: Functions

| Function | File | Purpose | Error handling |
|---|---|---|---|
| `fn_annual_salary(p_monthly_salary)` | B1 | Monthly x 12 | NULL returns NULL; negative raises `ORA-20001` |
| `fn_years_of_service(p_hire_date)` | B2 | Complete years since hire date | NULL returns NULL; future date raises `ORA-20002` |
| `fn_calculate_tax(p_annual_salary)` | B3 | Progressive annual tax | Negative raises `ORA-20003` |
| `fn_dept_name(p_dept_id)` | B4 | Department name | Not found or NULL returns `'Unknown'` |

**Tax bands (B3, assumed from annualised Rwanda PAYE):**

| Annual salary | Rate |
|---|---|
| 0 - 720,000 | 0% |
| 720,001 - 1,200,000 | 20% |
| Above 1,200,000 | 30% |

**Test results (`test_functions.sql`):** `fn_annual_salary(500000)` = 6,000,000; tax(500,000) = 0; tax(1,000,000) = 56,000; tax(2,000,000) = 336,000; `fn_dept_name(10)` = Finance; `fn_dept_name(99)` = Unknown.

### B5: Functions in SQL
`03_tests/B5_functions_in_select.sql`
One `SELECT` that uses all four functions on the `employees` table. Employee 108 is excluded because the hire date is in the future.

<img width="2546" height="970" alt="B5_select_output" src="https://github.com/user-attachments/assets/ccc4f9e8-063e-464e-b9a2-52f5c7701e9e" />


---

## 8. Part C: Combined Task

### C1: Payroll Validator
`02_functions/C1_fn_validate_payroll.sql` and `03_tests/test_validate_payroll.sql`
`fn_validate_payroll(emp_id)` returns `VALID` or `INVALID: <reason>`. It checks: salary > 0, hire date not in the future, valid department, tax not above annual salary. Each failed check uses `GOTO done` so the function has one single exit point.

| Employee | Expected result |
|---|---|
| 101 | `VALID` |
| 106 | `INVALID: employee has no valid department.` |
| 107 | `INVALID: salary must be greater than zero.` |
| 108 | `INVALID: hire date is in the future.` |
| 999 | `INVALID: employee 999 not found.` |

<img width="2539" height="1087" alt="C1_output" src="https://github.com/user-attachments/assets/e12d9642-3f77-41d4-b94a-5ab5f13a39a5" />
<img width="2527" height="1050" alt="C1_output_2" src="https://github.com/user-attachments/assets/2b0dca51-9396-42cb-8360-d3015cfb31af" />



### C2: Reflection
See [docs/REFLECTION.md](docs/REFLECTION.md).

---

## 9. Key Concepts (quiz preparation)
- A label looks like `<<label>>` and must be followed by an executable statement.
- `GOTO` can jump **out of** a block but never **into** an IF, LOOP or nested block, nor into an exception handler.
- Structured code (IF / CASE / loops) is usually preferred over GOTO because it is easier to read and maintain.
- A function must `RETURN` a value and can be called inside SQL statements.
- `NO_DATA_FOUND` is raised when `SELECT INTO` returns no rows; `RAISE_APPLICATION_ERROR` uses codes -20000 to -20999.

## 10. Notes
- **AI usage:** I used an AI assistant (Claude) to help draft the initial code structure and documentation. I reviewed, ran and tested all the code myself and I can explain every part of it.
- The tax bands and salary-review bands are my own assumptions, as the assignment did not specify exact figures.
- The repository contains at least 5 meaningful commits.
