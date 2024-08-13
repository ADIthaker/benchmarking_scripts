#!/bin/bash

count=32 #number of cpus
i=1

if1_name=enp1s0f0
if2_name=enp6s0f0

echo "Enabling HT"
./enable_ht

# echo "Enable CPUs"
# ./enable_cpus

echo "Enabling CPUs"
while [[ $i -lt $count ]]
do
    #sudo ip route del 10.10.$((i + begin)).0/24 via 10.10.2.1
    #echo $i
    echo 1 > /sys/devices/system/cpu/cpu$i/online
	((i = i + 1)) 
done

echo "Configuring HW queues"
ethtool -L $if1_name combined 8
ethtool -L $if2_name combined 32

echo "Setting IRQ affinity"
i=1
cpu_list=0
while [[ $i -lt $count ]]
do
    cpu_list=$cpu_list,$i
	((i = i + 1)) 
done

./set_irq_affinity_cpulist.sh $cpu_list $if1_name
./set_irq_affinity_cpulist.sh $cpu_list $if2_name