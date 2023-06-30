#!/bin/bash

source functionLibrary.sh
function diskreport { 
    Drive_Partition_0=$(echo "$LsblkOutput" | grep -w "sda" | awk '{print$1}')
    Drive_Partition_1=$(echo "$LsblkOutput" | grep -w "sda1" | awk '{print$1}')
    Drive_Partition_2=$(echo "$LsblkOutput" | grep -w "sda2" | awk '{print$1}')
    Drive_Partition_3=$(echo "$LsblkOutput" | grep -w "sda3" | awk '{print$1}')
    
    Drive_Vendor_0=$(echo "$LshwOutput" | grep -A10 "\*\-disk" | grep vendor | sed 's/.*vendor: //')
    Drive_Vendor_1=$(echo "$LshwOutput" | grep -m1 -A7 "\*\-volume:0" | grep vendor | sed 's/.*vendor: //')
    Drive_Vendor_2=$(echo "$LshwOutput" | grep -m1 -A7 "\*\-volume:1" | grep vendor | sed 's/.*vendor: //')
    Drive_Vendor_3=$(echo "$LshwOutput" | grep -m1 -A7 "\*\-volume:2" | grep vendor | sed 's/.*vendor: //')

    Drive_Model_0=$(echo "$LshwOutput" | grep -A10 "\*\-disk" | grep 'product' | sed 's/.*product: //' )

    Drive_Size_0=$(echo "$LsblkOutput" | grep -w 'sda' | awk '{print $4}' | sed 's/$/B/')
    Drive_Size_1=$(echo "$LsblkOutput" | grep -w 'sda1' | awk '{print $4}' | sed 's/$/B/')
    Drive_Size_2=$(echo "$LsblkOutput" | grep -w 'sda2' | awk '{print $4}' | sed 's/$/B/')
    Drive_Size_3=$(echo "$LsblkOutput" | grep -w 'sda3' | awk '{print $4}' | sed 's/$/B/')

    Drive_Filesystem_Size_sda2=$(df -h | grep -w 'sda2' | awk '{print$2}' | sed 's/$/B/')
    Drive_Filesystem_Size_sda3=$(df -h | grep -w 'sda3' | awk '{print$2}' | sed 's/$/B/')

    Drive_Free_Space_sda2=$(df -h | grep -w 'sda2' | awk '{print$4}' | sed 's/$/B/') 
    Drive_Free_Space_sda3=$(df -h | grep -w 'sda3' | awk '{print$4}' | sed 's/$/B/') 

        # If any drive mountpoints are blank/empty, user receives an N/A in drive table
    Drive_Mntpt_0=$(echo "$LsblkOutput" | grep -w "sda" | awk '{print$7}')
    if [[ "${Drive_Mntpt_0}" == "" ]]; then
        Drive_Mntpt_0="N/A"
    fi
    Drive_Mntpt_1=$(echo "$LsblkOutput" | grep -w "sda1" | awk '{print$7}')
    if [[ "${Drive_Mntpt_1}" == "" ]]; then
        Drive_Mntpt_1="N/A"
    fi
    Drive_Mntpt_2=$(df -h | grep -w 'sda2' | awk '{print$6}')
    Drive_Mntpt_3=$(df -ah | grep 'sda3' | tail -n1 | awk '{print$6}')

        # Creates a structured table to display Disk variables from diskreport function
            # First Column of table
    Drive_Table=$(paste -d ';' <(echo "$Drive_Partition_0" ; echo "$Drive_Partition_1" ; 
        echo "$Drive_Partition_2" ; echo "$Drive_Partition_3" ) <(
            # Second column of table
        echo "$Drive_Vendor_0" ; echo "$Drive_Vendor_1" ; echo "$Drive_Vendor_2" ; echo "$Drive_Vendor_3") <(
            # Third column of table
        echo "$Drive_Model_0" ; echo N/A ; echo N/A ; echo N/A) <(
        # Fourth column of table
    echo "$Drive_Size_0" ; echo "$Drive_Size_1" ; echo "$Drive_Size_2" ; echo "$Drive_Size_3") <(
        # Fifth column of table
    echo N/A ; echo N/A ; echo "$Drive_Filesystem_Size_sda2" ; echo "$Drive_Filesystem_Size_sda3") <(
        # Sixth column of table
    echo N/A ; echo N/A ; echo "$Drive_Free_Space_sda2" ; echo "$Drive_Free_Space_sda3") <(
        # Seventh column of table
    echo "$Drive_Mntpt_0" ; echo "$Drive_Mntpt_1" ; echo "$Drive_Mntpt_2" ; echo "$Drive_Mntpt_3" ) |
        # column cmd used to create table from variables gathered above
    column -N 'Logical Name (/dev/sda)',Vendor,Model,Size,'Filesystem Size','Filesystem Free Space','Mount Point' -s ';' -o ' | ' -t)

# Places disk report table info into a readable template form
cat << EOF
                                   
                                                  **Disk Report**
                                                 -----------------
                                                *Installed Drives*
                                               -------------------- 
$Drive_Table
EOF
}
diskreport
