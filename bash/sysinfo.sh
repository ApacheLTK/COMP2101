#!/bin/bash
# This script will pull and display relevant system information
fqdn=$(hostname -f)
os=$(hostnamectl | awk 'NR==7 {print $3, $4, $5}')
ip=$(hostname -I)
freespace= $(df / -h | awk 'NR==2 {print $4}')
if [ $(whoami) != "root" ]; then echo 'must be root, try sudo'; exit 1; fi
#
#
#
cat <<EOF
Report for $USER
=====================
Computer Information:
=====================
FQDN: $fqdn
Manufacturer: $manufacturer
Model: $model
Serial: $serial
Operating System name and version: $os
Ip Addresses: $ip
Root Filesystem free space: $freespace
=========================================

EOF

cat <<EOF
Computer Information:
========================
Manufacturer: $pcManufacturer
Description: $pcDescription
Serial: $pcSerial
========================

CPU Information
=========================
Manufacturer: $cpuManufacturer
Architecture: $cpuArchitecture
Core Count: $cpuCoreCount
Maximum Speed: $cpuMaxSpeed
Size of Caches: $cpuCaches
========================

Operating System Information:
=============================
Linux Distro: $linuxDistro
Distro Version: $distroVersion

EOF
