#!/bin/bash
# This script will pull and display relevant system information

printf "Report for $(hostname)\n===============\n"
echo "FQDN: $(hostname -f)"
printf "Operating System name and version: " 
printf "$(hostnamectl)\n" | awk '{print$0}' | grep "Operating System" | awk '{print $3, $4, $5}'
printf "IP Address: $(hostname -I)\n"
printf "Root Filesystem Free Space: " && df / -h | awk 'NR==2 {print $4}' 
echo "==============="
