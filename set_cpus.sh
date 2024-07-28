#!/bin/bash

count=16 #number of cpus

node=$1-
first=$(( node * 8)) #all these calculations are for the cloudlab hardware type : c220g1
last=$(( first + 7))
next_first=$(( first + 16))
next_last=$(( next_first + 7))

IFNAME=enp1s0f0

echo "Killing irqbalance"
killall irqbalance

echo "Disabling HT"
./disable_ht

echo "Disabling CPUs"
./disable_cpus_no_ht

echo "Enabling CPUs"
i=$first
while [[ $i -le $last ]]
do
    #sudo ip route del 10.10.$((i + begin)).0/24 via 10.10.2.1
    echo $i
    echo 1 > /sys/devices/system/cpu/cpu$i/online
    ((i = i + 1))
done
i=$next_first
while [[ $i -le $next_last ]]
do
    #sudo ip route del 10.10.$((i + begin)).0/24 via 10.10.2.1
    echo $i
    echo 1 > /sys/devices/system/cpu/cpu$i/online
    ((i = i + 1))
done

echo "Configuring HW queues"
ethtool -L $IFNAME combined $count

echo "Setting IRQ affinity"
cpu_list=$first
i=$((first + 1))
while [[ $i -le $last ]]
do
    cpu_list=$cpu_list,$i
	((i = i + 1)) 
done
i=$next_first
while [[ $i -le $next_last ]]
do
    cpu_list=$cpu_list,$i
	((i = i + 1)) 
done
echo $cpu_list
./set_irq_affinity_cpulist.sh $cpu_list $IFNAME
