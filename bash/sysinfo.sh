#!/bin/bash
# This script will pull and display relevant system information
# There are options for this script too see (sysinfo.sh -h) to see the different options available
#
#Sourcing functionLibrary.sh and os-release file
source /etc/os-release
source reportfunctions.sh
#This line checks if the user is running the script with sudo as some commands that are run during the script process require/recommend the use of sudo so that information is completely shown
if [ "$(whoami)" != "root" ]; then echo 'must be root, try sudo'; exit 1; fi

# Default options for OPTIONS
fullReport=true
verbose=false
systemReport=false
diskReport=false
networkReport=false

#  CLI Processor to filter through options provided by user
while [ $# -gt 0 ]; do
	case ${1} in
	     -h)
		helpPage
		exit 0
		;;
	     -v)
		set -v
		fullReport=false
		;;
	     -system)
		systemReport=true
		fullReport=false
		;;
	     -disk)
		diskReport=true
		fullReport=false
		;;
	     -network)
		networkReport=true
		fullReport=false
		;;
		*)
		echo "Umm, that was an invalid option try (sysinfo.sh -h) to see the help page and all options"
		errormessage "$@"
		exit 1
		;;
	esac
	shift
done

#Default behaviour of script when no options are selected
if [[ "$fullReport" == true ]]; then
   cpureport
   computerreport
   osreport
   ramreport
   videoreport
   diskreport
   networkreport
fi

if [[ "$verbose" == true ]]; then
   fullReport=false
   error-message
fi

if [[ "$diskReport" == true ]]; then
   fullReport=false
   diskreport
fi

if [[ "$networkReport" == true ]]; then
   fullReport=false
   networkreport
fi

if [[ "$systemReport" == true ]]; then
   fullReport=false
   computerreport
   osreport
   cpureport
   ramreport
   videoreport
fi
