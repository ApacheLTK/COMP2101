#!/bin/bash
#This is a function library containing different functions for gathering information on the local computer system
###
#Function for gathering CPU information
###
function cpureport {

mycpu=$(lscpu|grep 'Model name:'|sed 's/.*Model name: *//')
mycpucurrentspeed=$(lshw -class processor| grep size|tail -1|awk '{print $2}' )
mycpumaxspeed=$(lshw -class processor| grep capacity|tail -1|awk '{print $2}' )
cpuvendor=$(lshw -class processor| grep vendor|tail -1|awk '{print $2}' )
cpuCoreCount=$(nproc)
l1Cache=$(lscpu --caches | grep -m1 L1 | awk '{print $3}' | sed 's/K/KB/')
l2Cache=$(lscpu --caches | grep L2 | awk '{print $3}' | sed 's/M/MB/')
l3Cache=$(lscpu --caches | grep L3 | awk '{print $3}' | sed 's/M/MB/')
cat << EOF

------------------
| CPU Information |
 -----------------
| CPU Model:               | $mycpu |
| CPU Vendor/Manufacturer: | $cpuvendor | 
| CPU Core Count:          | $cpuCoreCount
| Max Speed:               | $mycpumaxspeed |
| CPU L1 Cache:            | $l1Cache
| CPU L2 Cache:            | $l2Cache
| CPU L3 Cache:            | $l3Cache

EOF

}
#
####
#Function for gathering Computer information
####
function computerreport {
pcManufacturer=$(hostnamectl | grep Vendor: | sed 's/.*Vendor:*//')
pcModel=$(hostnamectl | grep Model: | sed 's/.*Model:*//')
pcSerial=$(lshw -C system | grep serial: | sed 's/.*serial:*//')
cat << EOF

-----------------------
| Computer Information |
 ----------------------
| Manufacturer:        | $pcManufacturer |
| Description / Model: | $pcModel |
| Serial Number:       | $pcSerial |

EOF
}

#Function for gathering Operating system information
function osreport {
osDistro=$(hostnamectl | grep "Operating System:" | awk '{print $3}')
osVersion=$(hostnamectl | grep "Operating System:" | awk '{print $4}')
cat << EOF

--------------------------------
| Operating System Information |
--------------------------------
| Linux Distro : $osDistro
| Distro Version : $osVersion

EOF
}

#Function for gathering RAM information
function ramreport {
ramManufacturer=$(dmidecode -t memory | grep Manufacturer | tail -1 | sed 's/.*Manufacturer: //')
ramModel=$(dmidecode -t memory | grep Serial | tail -1 | sed 's/.*Serial Number: //')
ramSize=$(dmidecode -t memory | grep -A4 socket | tail -1 | awk '{print $3,$4}')
ramSpeed=$(dmidecode -t memory | grep Speed | tail -1 | sed 's/.*Speed: //')
ramLocation=$(dmidecode -t memory | grep socket | tail -1 | sed 's/.*RAM//')
ramTotalSize=$(free -h --total | grep Total: | awk '{print $2}')
ramTable=$(echo "| Manufacturer | Model | Memory | Speed | Location | 
| ${ramManufacturer} | $ramModel | $ramSize | $ramSpeed | ${ramLocation} |" | column -t -s "|" -o "| ")

cat << EOF

-------------
| Ram Table |
-------------
$ramTable
------------------
| Ram Total Size |
------------------
| $ramTotalSize |

EOF
}

#Function for gathering Video card information
function videoreport {
videoManufacturer=$(lshw -C video | grep vendor: | sed 's/.*vendor: //')
videoDescription=$(lshw -C video | grep description: | sed 's/.*description: //')
cat << EOF

--------------------------
| Video Card Information |
--------------------------
| Manufacturer: $videoManufacturer |
| Description: $videoDescription |

EOF
}

#Function for gathering Disk Drive information
function diskreport {
driveZeroVendor=$(lshw | grep -m1 -A8 disk | grep vendor | sed 's/.*vendor: //')
driveOneVendor=$(lshw | grep -m1 -A7 volume:0 | grep vendor | sed 's/.*vendor: //')
driveTwoVendor=$(lshw | grep -m1 -A7 volume:1 | grep vendor | sed 's/.*vendor: //')
driveThreeVendor=$(lshw | grep -m1 -A7 volume:2 | grep vendor | sed 's/.*vendor: //')
driveModel=$(lshw | grep -A8 disk | grep product | sed 's/.*product: //')
driveZeroSize=$(lsblk | grep -w sda | awk '{print $4}')
driveOneSize=$(lsblk | grep -w sda1 | awk '{print $4}')
driveTwoSize=$(lsblk | grep -w sda2 | awk '{print $4}')
driveThreeSize=$(lsblk | grep -w sda3 | awk '{print $4}')
driveZeroPartition=$(lsblk | grep -w sda | awk '{print $1}') 
driveOnePartition=$(lsblk -l | grep -w sda1 | awk '{print $1}')
driveTwoPartition=$(lsblk -l | grep -w sda2 | awk '{print $1}')
driveThreePartition=$(lsblk -l | grep -w sda3 | awk '{print $1}')
#Drives zero and one are not mounted, placing "N/A" in variable to show the partition is not mounted
driveZeroMount=$(lsblk -l | grep -w sda | awk '{print $7}')
driveOneMount=$(lsblk -l | grep -w sda1 | awk '{print $7}')
driveTwoMount=$(lsblk -l | grep -w sda2 | awk '{print $7}')
driveThreeMount=$(lsblk -l | grep -w sda3 | awk '{print $7}')
# if statements that will check if the variable is blank, if so a N/A will be put into the variable to state there was no available mount point
if [[ ${driveZeroMount} == "" ]]; then
	driveZeroMount="N/A"
fi
if [[ ${driveOneMount} == "" ]]; then
	driveOneMount="N/A"
fi
if [[ ${driveTwoMount} == "" ]]; then
	driveTwoMount="N/A"
fi
if [[ ${driveThreeMount} == "" ]]; then
	driveThreeMount="N/A"
fi
driveTwoFilesystemSize=$(df -h | grep -w sda2 | awk '{print $2}')
driveTwoFilesystemFree=$(df -h | grep -w sda2 | awk '{print $4}')
driveThreeFilesystemSize=$(df -h | grep -w sda3 | awk '{print $2}')
driveThreeFilesystemFree=$(df -h | grep -w sda3 | awk '{print $4}')

diskTable=$(paste -d ';' <(echo "$driveZeroPartition" ; echo "$driveOnePartition" ; echo "$driveTwoPartition" ; echo "$driveThreePartition" ) <(
echo "$driveZeroVendor" ; echo "$driveOneVendor" ; echo "$driveTwoVendor" ; echo "$driveThreeVendor" ) <(
echo "$driveModel" ; echo 'N/A' ; echo 'N/A' ; echo 'N/A' ) <(
echo "$driveZeroSize" ; echo "$driveOneSize" ; echo "$driveTwoSize" ; echo "$driveThreeSize" ) <(
echo "$driveZeroMount" ; echo "$driveOneMount" ; echo "$driveTwoMount" ; echo "$driveThreeMount" ) <(
echo "N/A" ; echo "N/A" ; echo "$driveTwoFilesystemSize" ; echo "$driveThreeFilesystemSize" ) <(
echo "N/A" ; echo "N/A" ; echo "$driveTwoFilesystemFree" ; echo "$driveThreeFilesystemFree" ) | 
column -N Name,Vendor,Model,Size,'Mount Point','Filesystem Size','Filesystem Free' -s ';' -o ' | ' -t)
cat << EOF

-----------------------------
| Disk Drive(s) Information |
-----------------------------
$diskTable

EOF
}

#Function for gathering Network interface information
function networkreport {
networkVendor=$(lshw -C network | grep vendor | sed 's/.*vendor: //')
networkModel=$(lshw -C network | grep product | sed 's/.*product: //')
networkLinkState=$(ip a | grep ens33 | grep state | sed 's/.*state //' | awk '{print $1}')
networkCurrentSpeed=$(lshw -C network | grep -m1 size | sed 's/.*size: //')
networkIpAddress=$(ip a | grep ens33 | grep inet | sed 's/.*inet //' | awk '{print $1}')
networkTable=$(paste -d ';' <(echo "$networkVendor" ) <(echo "$networkModel" ) <(echo "$networkLinkState" ) <(echo "$networkCurrentSpeed" ) <(echo "$networkIpAddress" ) | column -N Vendor,Model,'Link State','Current Speed','IP Address' -s ';' -o ' | ' -t )
cat << EOF

---------------------------------
| Network Interface Information |
---------------------------------
$networkTable

EOF
}

#Function used to save error messsages with a timestamp into log file /var/log/systeminfo.log and displays the error to the user
function errormessage {
timestamp=$(date)
errorMessage="$1"
echo "Uh-oh an error occurred at ""$timestamp"". Error: ""$errorMessage"" ; Please see the help page (sysinfo.sh -h)"|logger -t "$(basename "$0")" -i -p user.warning
}
# Function made for displaying help options when the user inputs -h on command line when calling the sysinfo.sh script
function helpPage {
cat << EOF

-------------------
| sysinfo.sh Help |
-------------------
| Use: sysinfo.sh [OPTION]
| Valid Args:
	-h (Displays help page)
	-v (Verbose output)
	-system (Runs functions; computerreport, osreport, ramreport, videoreport)
	-disk (Runs only diskreport)
	-network (Runs only networkreport)

Hope this helps :D Have a good day, eh!

EOF
}
