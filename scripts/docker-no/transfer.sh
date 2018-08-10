#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test.sh

# 1307068 = 1.3 GB
# 10000000 = 10 GB
# 740000000 = 740 GB

if [ ! -e "/opt/appdata/plexguide/data" ]
then
	echo 0 > /opt/appdata/plexguide/data
    data=$(awk '{print $1}' /opt/appdata/plexguide/data)
    echo "a date never existed"
    echo "$data"
else
	echo "file exists already"
	data=$(awk '{print $1}' /opt/appdata/plexguide/data)
	echo "$data"
fi

if [ ! -e "/opt/appdata/plexguide/switch" ]
then
	echo "on" > /opt/appdata/plexguide/switch
    switch=$(awk '{print $1}' /opt/appdata/plexguide/switch)
    echo "the switched never existed"
    echo "$switch"
else
	echo "switch already exists"
	switch=$(awk '{print $1}' /opt/appdata/plexguide/switch)
	echo "The switch is currently:"
	echo "$switch"
fi

#switch=$(awk '{print $1}' /opt/appdata/plexguide/switch)
if [ "$switch" == "off" ]; then
   echo "You Reached Your Limit for The Day!"
   exit 0
fi


a=$(du -la /mnt/move | grep "/mnt/move" | tail -1 | awk '{print $1}') && echo "$((a + 0))"
echo "first flag"
echo ""

while [ 1 -lt 740000000 ]
do
	data=$((data+0))

	if [ "$data" -gt 740000000 ]; then
	   	echo off > /opt/appdata/plexguide/switch
    	switch=$(awk '{print $1}' /opt/appdata/plexguide/switch)
       exit 0
    fi

	while [ "$a" -lt 100000 ]
	do

	a=$(du -la /mnt/move | grep "/mnt/move" | tail -1 | awk '{print $1}') && echo "$((a + 0))"

	sleep 5

		echo "Transfer will occur after 100MB is Collected"
		echo ""
	done

		data=$((data+0))
		data=$((data+a))
		echo "$data" > /opt/appdata/plexguide/data
		echo "finish flag"
		rm -r /opt/appdata/plexguide/rclone
		rclone move --tpslimit 6 --exclude='**partial~' --exclude="**_HIDDEN~" --exclude=".unionfs/**" --exclude=".unionfs-fuse/**" --checkers=16 --log-file=/opt/appdata/plexguide/rclone --max-size 99G --log-level INFO --stats 5s /mnt/move gdrive:/
		echo "sleeping for 120 seconds"
		sleep 120
		echo "resuming"

	a=$(du -la /mnt/move | grep "/mnt/move" | tail -1 | awk '{print $1}') && echo "$((a + 0))"

done
