#!/bin/bash
progName=$(basename -- "$0")
echo "$progName ver 1.5  written by Gcsholl"

# Customize rclone sync variables Below
# ---------------------------------------
rcloneName="gdmedia"
syncRoot="/home/pi/pi-timolo"
localSyncDir="images"
remoteSyncDir="picamera-motion/images"
# ---------------------------------------

# Display Users Settings
echo "----------- SETTINGS -------------
rcloneName   : $rcloneName
syncRoot     : $syncRoot
localSyncDir : $localSyncDir
remoteSyncDir: $remoteSyncDir
---------------------------------"
if pidof -o %PPID -x "$progName"; then
    echo "WARN  - $progName Already Running. Only One Allowed."
else
    if [ -f /usr/bin/rclone ]; then
        rclone -V   # Display rclone version
        if [ ! -d "$localSyncDir" ] ; then
           echo "---------------------------------------------------"
           echo "ERROR - localSyncDir=$localSyncDir Does Not Exist."
           echo "        Please Investigate Bye ..."
           exit 1
        fi

        /usr/bin/rclone listremotes | grep "$rcloneName"
        if [ $? == 0 ]; then
           echo "/usr/bin/rclone sync -v $localSyncDir $rcloneName:$remoteSyncDir"
           echo "One Moment Please ..."
           /usr/bin/rclone sync -v $localSyncDir $rcloneName:$remoteSyncDir
           if [ ! $? -eq 0 ]; then
               echo "---------------------------------------------------"
               echo "ERROR - rclone sync failed. Review output for Possible Cause"
           else
               echo "INFO  - Sync Successful ..."
           fi
        else
           echo "---------------------------------------------------"
           echo "ERROR - remoteName $rcloneName Does not Exist"
           echo "List of Remote Names"
           echo "-------------------"
           rclone listremotes
           echo "--------------------"
           echo "If List is Empty"
           echo "Configure a New Remote Storage Name per Command below"
           echo "    rclone config"
           echo "or Check Spelling of Variable rcloneName=$rcloneName"
           echo "For more Details See Readme.txt"
        fi
    else
        echo "ERROR  - /usr/bin/rclone Not Installed."
        echo "         You Must Install and Configure rclone"
    fi
fi
echo "---------------------------------------------------"
echo "$progName Bye ..."
