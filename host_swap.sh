#!/system/bin/sh

#Alex O'Connor
#Script to switch between hosts files, primarily for ad blocking

clear;
echo "------------------------------------------------------";
echo "------------------------------------------------------";
echo "------------------------------------------------------";
echo "                  __ __           __                 ";
echo "                 / // /___   ___ / /_ ___            ";
echo "                / _  // _ \ (_-</ __/(_-<            ";
echo "               /_//_/ \___//___/\__//___/            ";
echo "                    ____                             ";
echo "                   / __/_    __ ___ _ ___            ";
echo "                  _\ \ | |/|/ // _ \`// _ \          ";
echo "                 /___/ |__,__/ \_,_// .__/           ";
echo "                                   /_/               ";
echo "------------------------------------------------------";
echo "-----------------------AD BLOCKER---------------------";
echo "------------------------------------------------------";
echo

BLOCK="/etc/hosts.block"

if [ -f $BLOCK ]
        then
		
        echo $BLOCK found, swapping hosts

		#Get MD5 of each file. Removes file name to just store the MD5 value
		HOST=$(md5sum /etc/hosts | sed -e 's/\ .\/etc\/hosts.*//');
		HOSTU=$(md5sum /etc/hosts.unblock | sed -e 's/\ .\/etc\/hosts.*//');
		HOSTB=$(md5sum /etc/hosts.block | sed -e 's/\ .\/etc\/hosts.*//');

		echo \"$HOST\" hosts
		echo \"$HOSTU\" hosts.unblock
		echo \"$HOSTB\" hosts.block
		echo

		#Set system as rewritable
		busybox mount -o remount,rw -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		if [ "$HOST" == "$HOSTU" ] ; then
		   cp /etc/hosts.block /etc/hosts
		   echo "Ads now blocked..."
		else
		   cp /etc/hosts.unblock /etc/hosts
		   echo "Ads now unblocked..."
		fi

		#Set system as read-only
		busybox mount -o remount,ro -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

	else
		#Set system as rewritable
        busybox mount -o remount,rw -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		if [ -f "/sdcard/Hosts_swap/hosts.block" ]
			then
		                cp /etc/hosts /etc/hosts.unblock
                		cp /sdcard/Hosts_swap/hosts.block /etc/hosts.block
		else
				echo hosts.block file not found...
				exit
		fi

		#Set system as read-only
                busybox mount -o remount,ro -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		clear
		echo Hosts files have been setup, rerun this script to switch between the two
		echo
fi

exit 0
