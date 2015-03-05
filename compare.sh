#!/bin/bash

for testno in  {0..9}
do
	diff testresults/result-$testno.txt testresults-solution/result-$testno.txt
done

