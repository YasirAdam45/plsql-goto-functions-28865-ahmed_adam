-- A3 - Illegal GOTO and Fix
SET SERVEROUTPUT ON

-- PART 1: ILLEGAL. GOTO cannot jump INTO an IF/LOOP/nested block.
-- Expected error: PLS-00375: illegal GOTO statement; this label is not within the scope of the GOTO statement
DECLARE
    v_x NUMBER := 5;
BEGIN
    GOTO inside_if;          -- tries to jump into the IF block below

    IF v_x > 0 THEN
        <<inside_if>>
        DBMS_OUTPUT.PUT_LINE('Inside the IF block');
    END IF;
END;
/

-- PART 2: FIX. Put the label in the same (or an enclosing) block as the GOTO,
-- and keep the conditional logic in a normal IF.
DECLARE
    v_x NUMBER := 5;
BEGIN
    IF v_x > 0 THEN
        GOTO show_message;   -- jumping OUT of an IF to an outer label is legal
    END IF;

    DBMS_OUTPUT.PUT_LINE('Skipped when v_x > 0');

    <<show_message>>
    DBMS_OUTPUT.PUT_LINE('Fixed: label is in the enclosing block, so GOTO is legal.');
END;
/
