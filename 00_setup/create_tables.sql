-- 00_setup/create_tables.sql
-- Author: Ahmed Adame (ID 28865) | INSY 8311
-- Creates the tables and sample data used by all other scripts.

BEGIN EXECUTE IMMEDIATE 'DROP TABLE employees PURGE';   EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE departments PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE departments (
    dept_id    NUMBER(4)     PRIMARY KEY,
    dept_name  VARCHAR2(50)  NOT NULL
);

CREATE TABLE employees (
    emp_id         NUMBER(6)     PRIMARY KEY,
    first_name     VARCHAR2(30)  NOT NULL,
    last_name      VARCHAR2(30)  NOT NULL,
    hire_date      DATE          NOT NULL,
    monthly_salary NUMBER(12,2),
    dept_id        NUMBER(4)     REFERENCES departments(dept_id)
);

INSERT INTO departments VALUES (10, 'Finance');
INSERT INTO departments VALUES (20, 'IT');
INSERT INTO departments VALUES (30, 'Human Resources');

INSERT INTO employees VALUES (101, 'Alice',  'Uwase',    DATE '2015-03-01', 1500000, 10);
INSERT INTO employees VALUES (102, 'Brian',  'Mugisha',  DATE '2018-07-15',  800000, 20);
INSERT INTO employees VALUES (103, 'Chantal','Ingabire', DATE '2021-01-10',  450000, 30);
INSERT INTO employees VALUES (104, 'David',  'Habimana', DATE '2023-09-01',  250000, 20);
INSERT INTO employees VALUES (105, 'Esther', 'Mukamana', DATE '2010-05-20', 1100000, 10);
-- Deliberately invalid rows for testing the payroll validator (C1)
INSERT INTO employees VALUES (106, 'Franck', 'Niyonzima',DATE '2020-02-02',  600000, NULL);      -- no department
INSERT INTO employees VALUES (107, 'Grace',  'Uwera',    DATE '2019-04-04',       0, 20);        -- zero salary
INSERT INTO employees VALUES (108, 'Henry',  'Kalisa',   SYSDATE + 30,       700000, 10);       -- future hire date
COMMIT;
