#!/bin/bash

users="$(cut -d: -f1,3 /etc/passwd)"
for liam in $users; do
	username=$(cut -d: -f1 <<< $liam)
	userid=$(cut -d: -f2 <<< $liam)
	if [ $userid -gt 999 ]; then
		if [ ! -v allusers ]; then
			allusers="$username"
		else
			allusers+=" $username"
		fi
	fi
done
echo "Found these users: $allusers"
