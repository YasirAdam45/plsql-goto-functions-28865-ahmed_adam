-- A1 - Number Classifier (uses GOTO)
-- Classifies a number as positive / negative / zero, then even / odd.
SET SERVEROUTPUT ON
DECLARE
    v_num NUMBER := 7;   -- change this value to test: 7, -4, 0, 10
BEGIN
    DBMS_OUTPUT.PUT_LINE('Number: ' || v_num);

    IF v_num > 0 THEN
        GOTO positive_number;
    ELSIF v_num < 0 THEN
        GOTO negative_number;
    ELSE
        GOTO zero_number;
    END IF;

    <<positive_number>>
    DBMS_OUTPUT.PUT_LINE('Sign   : Positive');
    GOTO check_parity;

    <<negative_number>>
    DBMS_OUTPUT.PUT_LINE('Sign   : Negative');
    GOTO check_parity;

    <<zero_number>>
    DBMS_OUTPUT.PUT_LINE('Sign   : Zero (neither positive nor negative)');
    GOTO end_check;

    <<check_parity>>
    IF MOD(v_num, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Parity : Even');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Parity : Odd');
    END IF;

    <<end_check>>
    DBMS_OUTPUT.PUT_LINE('Classification complete.');
END;
/
