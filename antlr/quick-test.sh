#!/bin/bash

# arguments:
# 1: filename
run_on_file() {
  # check if there's an input file 
  # get filename without extension
  input=$1
  input="${input%.*}.in"

  # compile
  ./driver $1 > output.il
	
  if test -f $input ; then
	  java -jar ../iloc.jar -s $1 < $input > original.txt
  else
    java -jar ../iloc.jar -s $1 > original.txt
  fi

  if test -f $input ; then
	  java -jar ../iloc.jar -s output.il < $input > optimized.txt
  else
    java -jar ../iloc.jar -s output.il > optimized.txt
  fi

  if diff original.txt optimized.txt ; then
    echo "(No difference)"
  fi
}

if [ $# -eq 0 ] ; then
  # do it on everything
  for f in ../input/*.il ; do
    echo running on $f
    run_on_file $f
    printf "\n"

  done
else
  # just one
  echo running on $1
  run_on_file $1
fi

# clean up
rm original.txt optimized.txt output.il
