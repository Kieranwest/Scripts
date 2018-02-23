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

if [[ $temp < 39 ]]
	then
		echo "$timestamp - Temperature is $temp. 10% Fan Speed" >> $logfile
		ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff 0xA #10% Fan Speed
fi

if [[ $temp > 40 && $temp < 44 ]]
	then
		echo "$timestamp - Temperature is $temp. 12% Fan Speed" >> $logfile
		ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff 0xC #12% Fan Speed
fi

if [[ $temp > 45 && $temp < 49 ]]
	then
		echo "$timestamp - Temperature is $temp. 15% Fan Speed" >> $logfile
		ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff 0xF #15% Fan Speed
fi

if [[ $temp > 50 && $temp < 54 ]]
	then
		echo "$timestamp - Temperature is $temp. 17% Fan Speed" >> $logfile
		ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff 0x11 #17% Fan Speed
fi

if [[ $temp > 55 ]]
	then
		echo "$timestamp - Temperature is $temp. 20% Fan Speed" >> $logfile
		ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff 0x14 #20% Fan Speed
fi
