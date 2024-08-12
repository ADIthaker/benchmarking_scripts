#### Commands to start the experiment on server:
```
sudo -s
./reset_cpus.sh # starts all cpus again
./set_cpus.sh 0 1 #First arg is node no {0, 1}, second arg is interface number {1, 2}.
numactl --cpunodebind=0 --membind=0 iperf3 -s
```
#### Commands to start the experiment on client:
```
iperf3 -c IP_ADDR
```
