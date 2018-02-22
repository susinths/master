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

TESTFILENAME="test_$(date +%F_%H-%M-%S)_bm_to_bm.txt"

#while true; do echo -n "$(rperf   -c 192.168.100.1 -p 5001 -H -G pw -l 500M -y C) " >> test1_bm_to_bm.txt && cat /proc/loadavg >> test1_bm_to_bm.txt; done
echo -e "Timestamp\t Bandwidth\t CPULoad1m CPULoad5m CPULoad5m NetDevRX NetDevTX " > $TESTFILENAME 
while true
do echo -n "$(date +%F_%H-%M-%S), " >> $TESTFILENAME && 
echo -n "$(ib_send_bw -D $RUNTIME  -m 4096 -d mlx4_0 -i 1 -F --report_gbits  $IP_SRV --output=bandwidth)," >> $TESTFILENAME  
echo -n  $(awk '{print $1 ", " $2 ", " $3 ", "}' /proc/loadavg) >> $TESTFILENAME
echo -n $(cat /proc/net/dev | awk "/${IF}:/ {print \$2}"),  >> $TESTFILENAME     
echo  $(cat /proc/net/dev | awk "/${IF}:/ {print \$10}")  >> $TESTFILENAME     
    sleep 2
done

#TODO add capture of cat /proc/net/dev | awk "/${IF}:/ {print \$1,\$2,\$10}"
