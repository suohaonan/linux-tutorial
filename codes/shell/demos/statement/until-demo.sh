#!/usr/bin/env bash

x=0
until [[ ${x} -ge 5 ]]; do
    echo ${x}
    x=`expr ${x} + 1`
done
#  Output:
#  0
#  1
#  2
#  3
#  4
