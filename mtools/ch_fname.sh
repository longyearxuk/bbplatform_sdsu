#!/bin/bash

for file in `ls | grep _rlz_`
do
  fn1=${file:0:10}
  fn1n=`echo $fn1 | sed 's/1/2/g'`
  fn3=${file:10}
  mv $file $fn1n$fn3
done

#fn2n=0
#for file in `ls | grep .rd100`
#do
#  fn1=${file:0:3}
#  fn1n=`echo $fn1 | sed 's/7/8/g'`
#  fn2n=$(echo "$fn2n + 1"|bc)
#  fn2n=`printf "%02d" $fn2n`
#  fn3=${file:5}
#  mv $file $fn1n$fn2n$fn3
#done
