REPORT ZESTUDOS1.

TYPES: BEGIN OF GS_USER,                  "Global Structure"
         LV_SALBASE    TYPE P DECIMALS 2, "Base Salary"
         LV_EXTRAHRS   TYPE P DECIMALS 2, "Extra Hours"
         LV_DEDUCTIONS TYPE P DECIMALS 2, "Company Deductions"
         LV_BONUS      TYPE P DECIMALS 2, "Company Bonus"
         LV_TRIBUTE    TYPE P DECIMALS 2, "Government Taxes"
         LV_BRUTESAL   TYPE P DECIMALS 2, "Gross Salary"
         LV_TOTRIBUTE  TYPE P DECIMALS 2, "Total Taxes"
         LV_LIQUIDSAL  TYPE P DECIMALS 2, "Net Salary"
         LV_BONUSTOT   TYPE P DECIMALS 2, "Total Bonus"
       END OF GS_USER.

DATA: LS_USER2 TYPE GS_USER. "Local Structure"

START-OF-SELECTION.

  PARAMETERS:                                                   "User Inputs"
    P_NAME  TYPE C LENGTH 15,                                   "Name"
    P_SALBA TYPE P DECIMALS 2,                                  "Base Salary"
    P_EXTR  TYPE P DECIMALS 2.                                  "Extra Hours"

SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK RADIO1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:
    DAY     TYPE BOOLEAN RADIOBUTTON GROUP GRP1 DEFAULT 'X',    "Radio buttons based on worked extra hours shifts"
    EVENING TYPE BOOLEAN RADIOBUTTON GROUP GRP1,
    NIGHT   TYPE BOOLEAN RADIOBUTTON GROUP GRP1,
    HOLYDAY TYPE BOOLEAN RADIOBUTTON GROUP GRP1.
SELECTION-SCREEN END OF BLOCK RADIO1.
SKIP 1.
  PARAMETERS:
    P_DEDU  TYPE P DECIMALS 2,                                  "Company Deductions"
    P_BONU  TYPE P DECIMALS 2.                                  "Company Bonus"

  IF P_SALBA =< '760.00'.                             "A flow control to set percentages based on Base Salary"
    LS_USER2-LV_BONUSTOT = ( 3 / 100 ) * P_SALBA.
  ELSEIF P_SALBA > '760.00' AND P_SALBA =< '1500.00'.
    LS_USER2-LV_BONUSTOT = ( 2 / 100 ) * P_SALBA.
  ELSE.
    LS_USER2-LV_BONUSTOT = ( '1.5' / 100 ) * P_SALBA.
  ENDIF.

  IF P_SALBA =< '760.00'.                             "A flow control to set taxes based on Base Salary"
    LS_USER2-LV_TRIBUTE = ( '1.5' / 100 ) * P_SALBA.
  ELSEIF P_SALBA > '760.00' AND P_SALBA =< '1500.00'.
    LS_USER2-LV_TRIBUTE = ( 2 / 100 ) * P_SALBA.
  ELSE.
    LS_USER2-LV_BONUSTOT = ( 3 / 100 ) * P_SALBA.
  ENDIF.

  IF DAY = 'X'.           "A flow control to calculate the value of extra hour"
    P_EXTR = P_EXTR * 2.
  ELSEIF EVENING = 'X'.
    P_EXTR = P_EXTR * '2.5'.
  ELSEIF NIGHT = 'X'.
    P_EXTR = P_EXTR * 3.
  ELSEIF HOLYDAY = 'X'.
    P_EXTR = P_EXTR * 4.
  ELSE.
    P_EXTR = P_EXTR * 1.
  ENDIF.

  LS_USER2-LV_SALBASE = P_SALBA.
  LS_USER2-LV_EXTRAHRS = P_EXTR.
  LS_USER2-LV_DEDUCTIONS = P_DEDU.
  LS_USER2-LV_BONUS = P_BONU.
  LS_USER2-LV_BRUTESAL = P_SALBA + P_EXTR.                                                          "Gross Salary = Base Salary + Extra Hours"
  LS_USER2-LV_TOTRIBUTE = P_DEDU + LS_USER2-LV_TRIBUTE.                                             "Total Taxes = Company Deductions + Government Taxes"
  LS_USER2-LV_LIQUIDSAL = ( LS_USER2-LV_BRUTESAL + LS_USER2-LV_BONUSTOT ) - LS_USER2-LV_TOTRIBUTE.  "Net Salary = Gross Salary + Total Bonus - Total Taxes"

  "My local structure receives some of the user-entered data to perform necessary calculations."

WRITE: / 'NAME: ', P_NAME.
WRITE: / 'BASE SALARY: ', P_SALBA.
WRITE: / 'EXTRA HOURS VALUE: +', P_EXTR.
WRITE: / 'TOTAL TRIBUTE: -', LS_USER2-LV_TOTRIBUTE.
WRITE: / 'GROSS SALARY: ', LS_USER2-LV_BRUTESAL.
WRITE: / 'BONUS SALARY: +', P_BONU.
WRITE: / 'NET SALARY: ', LS_USER2-LV_LIQUIDSAL.

BREAK-POINT.
