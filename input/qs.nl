{** $awkdoc$ ********************************************************

A version of quicksort for testing recursion: reads and sorts
19 INTEGER.

** $endawk$ ********************************************************}

PROGRAM qs;
  VAR  A:  ARRAY [0..20] OF INTEGER;
PROCEDURE  readarray;
  VAR  i:  INTEGER;
BEGIN
  WRITE ('A?');
  i := 1;
  WHILE i < 20 DO
    BEGIN
      WRITE (i);
      READ (A[i]);
      i := i + 1
    END
END;
PROCEDURE  writearray;
  VAR  i:  INTEGER;
BEGIN
  WRITE ('A:');
  i := 1;
  WHILE i < 20 DO
    BEGIN
      WRITE (A[i]);
      i := i + 1
    END
END;
FUNCTION partition(
        B:  ARRAY [0..20] OF INTEGER;
      p,r:  INTEGER
) : INTEGER;
  VAR i, j: INTEGER;
      x, t,z: INTEGER;
BEGIN
  x := B[p];
  i := p - 1;
  j := r + 1;
  WHILE 1.7 DO
    BEGIN
      j := j-1;
      WHILE B[j] > x DO
        BEGIN
          j := j-1
        END;
      i := i+1;
      WHILE B[i] < x DO
        BEGIN
          i := i+1
        END;
      IF i < j
        THEN
          BEGIN
            t := B[i];
            B[i] := B[j];
            B[j] := t
          END
        ELSE
          RETURN j
    END
END;
PROCEDURE quicksort(
     Z: ARRAY [0..20] OF INTEGER;
     p,r: INTEGER
);
  VAR q:  INTEGER;
BEGIN
  IF p < r
    THEN
      BEGIN
        q := partition(Z,p,r);
        quicksort(Z,p,q);
        quicksort(Z,q+1,r)
      END
END;
BEGIN
  A[0] := 0-1; A[20] :=  1000;  { book does this; don't know why }
  readarray();
  writearray();
  quicksort(A,1,19);
  writearray()
END
