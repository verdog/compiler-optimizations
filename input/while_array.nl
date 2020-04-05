{*********************************************************

This testcase performs simple test on flow of control.

*********************************************************}

PROGRAM Flow;
 VAR a:INTEGER;
     c:ARRAY [1..10] OF INTEGER;

BEGIN


	a:=1;
        WHILE a <= 10 DO BEGIN
          c[a] := a;
	  a := a + 1
	END;

	a := 1;
        WHILE a <= 10 DO BEGIN
          IF (a < 5) THEN
            WRITE(c[a])
          ELSE
            WRITE(0);
	  a := a + 1
	END

END
