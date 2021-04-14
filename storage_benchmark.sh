#!/bin/bash
now=$( date '+DATE_%F__TIME_%H-%M' )
echo "Starting benchmark run $now:"
echo

x=1

echo "terse version;fio version;jobname;groupid;error;\
Read status - Total I/O (KB);Read status - bandwidth (KB/s);\
Read status - IOPS;Read status - runtime (ms);\
Total latency - min;Total latency - max;\
Total latency - mean;Total latency - standard deviation;\
Bandwidth - min;Bandwidth - max;Bandwidth - mean;\
Bandwidth - standard deviation;Write status - Total I/O (KB);\
Write status - bandwidth (KB/s);Write status - IOPS;\
Write status - runtime (ms);Total latency - min;\
Total latency - max;Total latency - mean;\
Total latency - standard deviation;Bandwidth - min;\
Bandwidth - max;Bandwidth - mean;Bandwidth - standard deviation"\
>> /root/test_results/benchmark__$now.csv

while [ $x -le 1001 ]
do
    echo "    - Running test $x. ($( date '+%H:%M' ))"

    rm -f /storage/test

    fio --randrepeat=1 --allrandrepeat=1 --randseed=5 \
    --loops=5 --ioengine=libaio --direct=1 --name=test$x \
    --filename=/storage/test --blocksize=8k --iodepth=64 \
    --size=100M --readwrite=randrw --rwmixread=50 \
    --output-format=terse \
    | cut -d ';' -f 1-9,38-43,45-50,79-84,86-87 \
    >> /root/test_results/benchmark__$now.csv

    echo "    - Done running test $x. ($( date '+%H:%M' ))"

    echo

    x=$(( $x + 1 ))
done

echo "The benchmark is finished. ($( date '+%H:%M' ))"
