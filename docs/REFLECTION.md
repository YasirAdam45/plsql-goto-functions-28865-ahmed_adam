# Reflection - Individual Assignment III

**Student:** Ahmed Adame (ID 28865) | **Course:** INSY 8311

## 1. What is GOTO and when did I use it?
`GOTO` transfers control unconditionally to a labelled statement (`<<label>>`). I used it in
A1 and A2 to jump to different branches, and in C1 to send every failed validation check to a
single exit point.

## 2. Why was the A3 GOTO illegal?
PL/SQL does not allow a jump *into* an IF, LOOP or nested block, nor into an exception handler.
My code jumped into an `IF` block, giving `PLS-00375: illegal GOTO statement`. The fix was to
put the label in the same or an enclosing block. Jumping *out* of a block is allowed.

## 3. GOTO vs structured code (A2 vs A4)
The IF/ELSIF version (A4) is shorter and easier to read and maintain. GOTO makes the flow
harder to follow ("spaghetti code"), so I would normally avoid it. It is acceptable for a
single early-exit label, as in C1.

## 4. Functions
Functions return one value and can be used directly in SQL (B5), which makes logic reusable
(annual salary, tax, years of service, department name). Exception handling matters: B4 returns
'Unknown' on `NO_DATA_FOUND`, and B1-B3 use `RAISE_APPLICATION_ERROR` for bad input.

## 5. Challenges
- Remembering that a label must be followed by an executable statement.
- Designing tax bands and checking my expected values by hand
  (e.g. 1,000,000 -> (1,000,000 - 720,000) x 20% = 56,000).
- Running scripts in the right order because the functions depend on the tables.

## 6. What I learned
Scope rules for GOTO, how to write and test functions, using functions inside SELECT
statements, and organising work in a clean GitHub repository.
