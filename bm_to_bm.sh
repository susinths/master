#! /usr/bin/env bash
#Bash script to run tests and record resulsts + system resource usage
IF="ens2"
IP_SRV="192.168.100.1"
OUTFILE="/root/scripts/ib_send_bw.txt"
RUNTIME="90" # in seconds                                                                                                                                                                                                                    
#PERFCMD="perf stat -e  cpu-migrations,context-switches,task-clock,cycles,instructions,cache-references,cache-misses"
#RPERFCMD="rperf -c $IP_SERVER -p 5001 -H -G pw -l 500M -i 2 -t $RUNTIME"
NETSTAT='cat /proc/net/dev | awk "/${IF}:/ {print \$1,\$2,\$10}"'
SLEEP="40"

TESTFILENAME="test_$(date +%F_%H-%M-%S)_vm8_to_compute7.txt"

#while true; do echo -n "$(rperf   -c 192.168.100.1 -p 5001 -H -G pw -l 500M -y C) " >> test1_bm_to_bm.txt && cat /proc/loadavg >> test1_bm_to_bm.txt; done
echo -e "Timestamp\t Bandwidth\t CPULoad1m CPULoad5m CPULoad5m NetDevRX NetDevTX IRQens2-0 IRQens2-1 IRQens2-2 IRQens2-3 IRQens2-4 IRQens2-5 IRQens2-6 IRQens2-7 user nice system idle iowait irq softirq steal guest guest_nice   " > $TESTFILENAME 
while true
do echo -n "$(date +%F_%H-%M-%S)," >> $TESTFILENAME && 
echo -n "$(ib_send_bw -D $RUNTIME  -m 4096 -d mlx4_0 -i 1 -F --report_gbits  $IP_SRV --output=bandwidth)," >> $TESTFILENAME  
echo -n  $(awk '{print $1 "," $2 "," $3 ","}' /proc/loadavg) >> $TESTFILENAME
echo -n $(cat /proc/net/dev | awk "/${IF}:/ {print \$2}"), >> $TESTFILENAME     
echo -n $(cat /proc/net/dev | awk "/${IF}:/ {print \$10}"),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-0$/ {print $2}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-1$/ {print $3}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-2$/ {print $4}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-3$/ {print $5}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-4$/ {print $6}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-5$/ {print $7}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-6$/ {print $8}  ' /proc/interrupts),  >> $TESTFILENAME     
echo  -n $(awk '/.*ens2-7$/ {print $9}  ' /proc/interrupts),  >> $TESTFILENAME     
echo     $(awk '/^cpu .*/ {print $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8 "," $9 "," $10 "," $11 }' /proc/stat) >> $TESTFILENAME

    sleep 2
done



#IRQs awk '/.*ens2-0$/ {print $2}  ' /proc/interrupts

#TODO add capture of cat /proc/net/dev | awk "/${IF}:/ {print \$1,\$2,\$10}"


#Start the "server" with 'while true; do ib_send_bw -D 90  -m 4096; done' 
