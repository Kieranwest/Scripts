#! /bin/bash

timestamp=$(date +"%d-%b-%Y @ %H:%M:%S")
logfile=/var/log/customFanController.log
let cores=0
total=0.0
for temp in $(sensors | grep "^Core" | grep -e '+.*C' | cut -f 2 -d '+' | cut -f 1 -d ' ' | sed 's/°C//'); do
    total=$(echo $total+$temp | bc)
    # Testing | echo $temp, $total
    let cores+=1
done
temp=$(echo "$total/$cores" | bc)

IDRACIP=""
IDRACUSER=""
IDRACPASSWORD=""
STATICSPEED="0xA" #Convert decimal to base 16
TEMPTHRESHOLD="50"

if [[ $temp > $TEMPTHRESHOLD ]]
   then
    echo "$timestamp - Temperature is $temp" >> $logfile
    echo "$timestamp - Enabling Dynamic Fan Control" >> $logfile
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x01
   else
    echo "$timestamp - Temperature is $temp" >> $logfile
    echo "$timestamp - Disabling Dynamic Fan Control" >> $logfile
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x00
    echo "$timestamp - Setting Static Fan Speed" >> $logfile
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff $STATICSPEED
fi
