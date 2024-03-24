#!/bin/bash
source ./../.env

getMessage() {
    read -r -d '' MSG <<- EOM
        {
            "uptime": "`uptime | awk -F "up|\," '{print $2}'`",
            "cpu": {
                "temperature": `cat /sys/class/thermal/thermal_zone0/temp`,
                "usage": {
                    "cpu0": "TODO",
                    "cpu1": "TODO",
                    "cpu2": "TODO",
                    "cpu3": "TODO"
                },
                "clock_frequency": {
                    "min": `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`,
                    "max": `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`,
                    "current": `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
                },
                "load_average": {
                    "1min":  `cat /proc/loadavg | awk '{print $1}'`,
                    "5min":  `cat /proc/loadavg | awk '{print $2}'`,
                    "15min": `cat /proc/loadavg | awk '{print $3}'`
                }
            },
            "memory": {
                "total": `free -m | awk '/^Mem:/ {print $2}'`,
                "used": `free -m | awk '/^Mem:/ {print $3}'`,
                "used_percentage": `free | awk '/^Mem:/ {printf "%.1f", ($3/$2) * 100}'`,
                "available": `free -m | awk '/^Mem:/ {print $7}'`
            },
            "disk": {
                "total": "`df -BM | awk '/^\/dev\// {total = $2; used = $3; available = $4} END {print total}'`",
                "used": "`df -BM | awk '/^\/dev\// {total = $2; used = $3; available = $4} END {print used}'`",
                "available": "`df -BM | awk '/^\/dev\// {total = $2; used = $3; available = $4} END {print available}'`",
                "used_percentage": `df -BM | awk '/^\/dev\// {total = $2; used = $3; available = $4} END {printf "%.1f", (used / (total + used)) * 100}'`
            }
        }
EOM
}

while [ true ]
do
    getMessage

    CMD="mosquitto_pub -h localhost -u $MQTT_USER -P $MQTT_PASS -t system/info -m $(echo $MSG | sed -r 's/[[:space:]]*//g' )"
    $CMD

    sleep 5
done