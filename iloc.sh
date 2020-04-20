#!/bin/bash

#!/bin/bash

# arguments:
# 1: filename
run_on_file() {
  # check if there's an input file 
  # get filename without extension
  filename=$1
  basename=$(basename $filename)

  # check if there's an input file 
  # get filename without extension
  input=$1
  input="${input%.*}.in"

  output="./output/${basename%.*}.ra.il"

  # compile
  time ./antlr/driver $1 > $output

  # test
  if test -f $input ; then
	  java -jar iloc.jar -s $filename < $input > original.txt
  else
    java -jar iloc.jar -s $filename > original.txt
  fi

  if test -f $input ; then
	  java -jar iloc.jar -s $output < $input > optimized.txt
  else
    java -jar iloc.jar -s $output > optimized.txt
  fi

  if diff original.txt optimized.txt ; then
    echo "(No difference)"
  fi
}

mkdir -p output

# do it on everything
for s in input/*.skip ; do
  echo skipping $s...
done
for f in input/*.il ; do
  echo
  echo running on $f
  run_on_file $f
done
echo "output files placed in output directory."

