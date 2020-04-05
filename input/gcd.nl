{ The sample program from the Oard document }

PROGRAM example;
   VAR x, y : INTEGER;
   FUNCTION gcd (a,b: INTEGER):INTEGER;
      BEGIN
         IF b=0
            THEN RETURN a
            ELSE RETURN gcd(b, a MOD b)
         END;
      BEGIN
         READ (x);
         READ (y);
         WHILE (x <> 0) OR (y <> 0) DO
            BEGIN
               WRITE (gcd (x,y));
               READ (x);
               READ (y)
               END
         END
