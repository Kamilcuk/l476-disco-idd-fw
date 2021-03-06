#!/bin/bash
set -xeuo pipefail; export SHELLOPTS
tmp=/tmp/.$(basename $0)
echo '
set term x11 nopersist noraise enhanced;

set title "Current meter";
set xlabel "Time [seconds]";
set ylabel "Current [miliampere]";
set autoscale;
set format x "%f";
set grid;

#plot "<(head -n1 /tmp/1)" u 1;
#XHIGHMIN=GPVAL_Y_MIN;
#plot "<(head -n1 /tmp/1)" u 1;
#XLOWMIN=GPVAL_Y_MIN;
#XMIN=XHIGHMIN

plot "<(tail -n'${2:-10000}' /tmp/1)" using \
( ( $1 * ( 2 ** 32 ) + $2) / 32000000 ) : ( \
  ( $5 - 0.1428571428 ) * ( \
    $3 == 0 ? 19.7379558227683 : \
    $3 == 1 ? 0.824306190911863 : \
    $3 == 2 ? 0.0338058276168833 : \
    0.00197359822245458 \
  ) \
) title "Measurements" with lines; 

while (0) {};
while (1) { replot; pause '${1:-1}'; };

' > $tmp
gnuplot -persist $tmp

