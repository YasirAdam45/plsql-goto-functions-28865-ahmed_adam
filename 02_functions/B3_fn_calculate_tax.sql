-- B3 - Progressive annual tax (based on Rwanda PAYE bands, annualised)
--   0       - 720,000   : 0%
--   720,001 - 1,200,000 : 20%
--   > 1,200,000         : 30%
CREATE OR REPLACE FUNCTION fn_calculate_tax (p_annual_salary IN NUMBER)
RETURN NUMBER
IS
    c_band1 CONSTANT NUMBER := 720000;
    c_band2 CONSTANT NUMBER := 1200000;
BEGIN
    IF p_annual_salary IS NULL THEN
        RETURN NULL;
    ELSIF p_annual_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Annual salary cannot be negative.');
    ELSIF p_annual_salary <= c_band1 THEN
        RETURN 0;
    ELSIF p_annual_salary <= c_band2 THEN
        RETURN (p_annual_salary - c_band1) * 0.20;
    ELSE
        RETURN (c_band2 - c_band1) * 0.20 + (p_annual_salary - c_band2) * 0.30;
    END IF;
END fn_calculate_tax;
/
SHOW ERRORS
