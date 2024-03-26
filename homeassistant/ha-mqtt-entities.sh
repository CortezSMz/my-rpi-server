#!/bin/bash
source ./../.env

createEntity() {
    UNIQUE_ID=$1
    DEVICE_CLASS=$2
    UNIT_OF_MEASUREMENT=$3
    NAME=$4

    read -r -d '' MSG <<- EOM
    {
        "unique_id": "rpi_$UNIQUE_ID",
        "device_class": "$DEVICE_CLASS",
        "unit_of_measurement": "$UNIT_OF_MEASUREMENT",
        "name": "$NAME",
        "state_topic": "system/$(echo $UNIQUE_ID | sed 's/_/\//g')"
    }
EOM

    MSG=$(echo $MSG | sed -rE 's/\s//g') 
    CMD="mosquitto_pub --retain -h localhost -u $MQTT_USER -P $MQTT_PASS -t homeassistant/sensor/$UNIQUE_ID/system/config -m $MSG"
    $CMD
}



createEntity uptime 'duration' 'min' 'RPi Uptime'

createEntity cpu_temperature temperature '°C' 'CPU Temperature'

createEntity cpu_usage_all power_factor '%' 'CPU Usage All'
createEntity cpu_usage_0 power_factor '%' 'CPU Usage 0'
createEntity cpu_usage_1 power_factor '%' 'CPU Usage 1'
createEntity cpu_usage_2 power_factor '%' 'CPU Usage 2'
createEntity cpu_usage_3 power_factor '%' 'CPU Usage 3'

createEntity cpu_loadavg_1min power_factor '' 'CPU Load Average 1min'
createEntity cpu_loadavg_5min power_factor '' 'CPU Load Average 5min'
createEntity cpu_loadavg_15min power_factor '' 'CPU Load Average 15min'

createEntity memory_total data_size 'mbit' 'Memory Total'
createEntity memory_used data_size 'mbit' 'Memory Used'
createEntity memory_available data_size 'mbit' 'Memory Available'

createEntity disk_total data_size 'kbit' 'Disk Total'
createEntity disk_used data_size 'kbit' 'Disk Used'
createEntity disk_available data_size 'kbit' 'Disk Available'
