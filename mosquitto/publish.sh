#!/bin/bash
source ./../.env

publish() {
    TOPIC=$1
    shift;
    MSG=$@
    CMD="mosquitto_pub --retain -h localhost -u $MQTT_USER -P $MQTT_PASS -t system/$TOPIC -m $MSG"
    $CMD
}

while [ true ]
do
    publish uptime `expr $(date +%s%N) - $(date --date="$(uptime -s)" +%s%N) | awk '{printf "%.2f", $1 / 60000000000}'`

    publish cpu/temperature `cat /sys/class/thermal/thermal_zone0/temp`

    publish cpu/usage/all `mpstat -P ALL -u | grep -E '\sall\s' | awk '{print $3}'`
    publish cpu/usage/0 `mpstat -P 0 -u | grep -E '\s0\s' | awk '{print $3}'`
    publish cpu/usage/1 `mpstat -P 1 -u | grep -E '\s1\s' | awk '{print $3}'`
    publish cpu/usage/2 `mpstat -P 2 -u | grep -E '\s2\s' | awk '{print $3}'`
    publish cpu/usage/3 `mpstat -P 3 -u | grep -E '\s3\s' | awk '{print $3}'`

    publish cpu/loadavg/1min  `cat /proc/loadavg | awk '{print $1}'`
    publish cpu/loadavg/5min  `cat /proc/loadavg | awk '{print $2}'`
    publish cpu/loadavg/15min `cat /proc/loadavg | awk '{print $3}'`
    
    publish memory/total `free -m | awk '/^Mem:/ {print $2}'`
    publish memory/used `free -m | awk '/^Mem:/ {print $3}'`
    publish memory/available `free -m | awk '/^Mem:/ {print $7}'`

    publish disk/total `df -k | awk '/^\/dev\/sda2/ {total = $2} END {print total}'`
    publish disk/used `df -k | awk '/^\/dev\/sda2/ {used = $3} END {print used}'`
    publish disk/available `df -k | awk '/^\/dev\/sda2/ {available = $4} END {print available}'`

    sleep 5
done
