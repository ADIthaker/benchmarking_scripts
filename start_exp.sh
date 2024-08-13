#!/bin/bash

echo "Running Reset CPUS"
./reset_cpus.sh

echo "Running Set CPUS"
./set_cpus.sh $1 2

numactl --cpunodebind=$1 --membind=$1 iperf3 -c 10.10.1.1 -B 10.10.1.2 > exp$1.log