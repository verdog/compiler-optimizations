PROGRAM check;

  VAR i,j:INTEGER;

BEGIN
	i := 1;
	WHILE i <= 10 DO BEGIN
	  IF i < 0 THEN j := 10 MOD 0;
	  i := i + 1
        END;
	WRITE('SUCCESS')
END
            
