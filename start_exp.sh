#!/bin/bash
numactl --cpunodebind=$1 --membind=$1 iperf3 -c 10.10.1.1 -B 10.10.1.2