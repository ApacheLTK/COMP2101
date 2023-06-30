#!/bin/bash
# this is the sysinfo script for lab 4
if [ $(whoami) != "root" ]; then echo 'must be root, try sudo'; exit 1; fi
myhostname=$(hostname)
mydate=$(date)

mycpu=$( lscpu|grep 'Model name:'|sed 's/.*Model name: *//')
mycpucurrentspeed=$(lshw -class processor| grep size|tail -1|awk '{print $2}' )
mycpumaxspeed=$(lshw -class processor| grep capacity|tail -1|awk '{print $2}' )
cpuvendor=$(lshw -class processor| grep vendor|tail -1|awk '{print $2}' )

source /etc/os-release

myfqdn=$(hostname -f)
if [[ ! $myfqdn =~ '.' ]]; then
	myfqdn+=" (no domain name available)"
fi

function cpureport { 
cat <<EOF
System info report produced by $USER on $mydate

System Info
-----------
| Hostname: $myfqdn |
| OS:       $PRETTY_NAME |


Processor Info
--------------
| CPU Model:               | $mycpu |
| CPU Vendor/Manufacturer: | $cpuvendor |
| Current Speed:           | $mycpucurrentspeed |
| Max Speed:               | $mycpumaxspeed |
EOF
}
cpureport
