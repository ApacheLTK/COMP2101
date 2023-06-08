#!/bin/bash
# This script will pull and display relevant system information
fqdn=$(hostname -f)
os=$(hostnamectl | awk 'NR==7 {print $3, $4, $5}')
ip=$(hostname -I)
freespace= $(df / -h | awk 'NR==2 {print $4}')
#
#
#
cat <<EOF
Report for $USER
=========================================
FQDN: $fqdn
Operating System name and version: $os
Ip Addresses: $ip
Root Filesystem free space: $freespace
=========================================

EOF

