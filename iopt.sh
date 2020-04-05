#!/bin/bash

#!/bin/bash

# arguments:
# 1: filename
run_on_file() {
  # check if there's an input file 
  # get filename without extension
  filename=$1
  basename=$(basename $filename)
  output="./output/${basename%.*}.opt.il"

  # compile
  time ./antlr/driver $1 > $output
}

mkdir -p output

# do it on everything
for f in input/*.il ; do
  echo running on $f
  run_on_file $f
done
echo "output files placed in output directory."

# output differences
cd antlr
./quick-test.sh
