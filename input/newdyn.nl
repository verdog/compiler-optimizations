PROGRAM newdyn;
	
  VAR source,target : ARRAY [1..30] OF INTEGER;
      cost : ARRAY [1..930] OF INTEGER;
      n,m,i,j : INTEGER;
              
BEGIN
              m := 30;
              n := 30;
              
              i := 1;
	      
              WHILE i <= m DO BEGIN
                cost[i*m+1] := i - 1;
                target[i] := i;
                i := i + 1
	      END;
              
              j := 1;
	      WHILE j <= n DO BEGIN
                cost[1*m+j] := j - 1;
                target[j] := 2 * j;
                j := j + 1
	      END;
              
              i := 2;
	      WHILE i <= m DO BEGIN	

                j := 2;
		WHILE j <= n DO BEGIN		
              
                  cost[i*m+j] := cost[(i - 1)*m+j - 1];
		  IF target[i] <> source[j] THEN
		    cost[i*m+j] := cost[i*m+j] + 1;

              	  IF cost[(i - 1)*m+j] < cost[i*m+j] THEN
		    cost[i*m+j] := cost[(i-1)*m+j] + 1;

                  IF cost[i*m+j - 1] < cost[i*m+j] THEN
                    cost[i*m+j] := cost[i*m+j - 1] + 1;
              
                  j := j + 1
	        END;
              
                i := i + 1

	      END;
              
              WRITE(cost[m*m+n])

END            
