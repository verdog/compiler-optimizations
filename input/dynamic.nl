PROGRAM dynamic;

  VAR source: ARRAY [1..19] OF INTEGER;
      target: ARRAY [1..16] OF INTEGER;
      cost: ARRAY [1..420] OF INTEGER;
      n,m,i,j,size: INTEGER;

BEGIN

  source[1] := 0;        
  source[2] := 1;        
  source[3] := 2;        
  source[4] := 3;        
  source[5] := 4;        
  source[6] := 5;        
  source[7] := 6;        
  source[8] := 7;        
  source[9] := 8;        
  source[10] := 9;        
  source[11] := 8;        
  source[12] := 7;        
  source[13] := 6;        
  source[14] := 5;        
  source[15] := 4;        
  source[16] := 3;        
  source[17] := 2;        
  source[18] := 1;        
  source[19] := 0;        

  target[1] := 0;
  target[2] := 1;
  target[3] := 3;
  target[4] := 5;
  target[5] := 7;
  target[6] := 9;
  target[7] := 11;
  target[8] := 4;
  target[9] := 3;
  target[10] := 2;
  target[11] := 1;
  target[12] := 9;
  target[13] := 8;
  target[14] := 7;
  target[15] := 6;
  target[16] := 0;
        
	size := 20;
        n := 1;

	WHILE source[n+1] <> 0 DO BEGIN
          cost[1*size+n] := n - 1;
          n := n + 1
        END;

        m := 1;
	WHILE target[m+1] <> 0 DO BEGIN
          cost[m*size+1] := m - 1;
          m := m + 1
        END;
        
	i := 2;
	WHILE i <= m DO BEGIN
	  j := 2;
	  WHILE j <= n DO BEGIN
            cost[i*size+j] := cost[(i - 1)*size+j - 1];
	    
	    IF target[i] <> source[j] THEN 
	       cost[i*size+j] := cost[i*size+j] + 1;
	    
	    IF cost[(i-1)*size+j] < cost[i*size+j] THEN
               cost[i*size+j] := cost[(i - 1)*size+j] + 1;

	    IF cost[i*size+j - 1] < cost[i*size+j] THEN 
               cost[i*size+j] := cost[i*size+j - 1] + 1;

	    j := j + 1

	  END;
	
	  i := i + 1

	END;
        
	WRITE(cost[m*size+n])
      
END
