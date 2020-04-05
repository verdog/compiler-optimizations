PROGRAM fib;

  VAR i,fib,old,new: INTEGER;

BEGIN
        old := 1;
        new := 0;
        fib := 0;
	i := 1;
	WHILE i <= 20 DO BEGIN
	  
	  WRITE(fib);
          fib := new + old;
          old := new;
          new := fib;

	  i := i + 1

	END
END
      
