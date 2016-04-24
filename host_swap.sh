#!/system/bin/sh

#Alex O'Connor
#Script to switch between hosts files, primarily for ad blocking

banner (){

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
	echo;
	
}

#Check MD5 of each hosts file to verify which is in use
hostsMD5 (){

	#Get MD5 of each file. Removes file name to just store the MD5 value
	HOST=$(md5sum /etc/hosts | sed -e 's/\ .\/etc\/hosts.*//');
	HOSTU=$(md5sum /etc/hosts.unblock | sed -e 's/\ .\/etc\/hosts.*//');
	HOSTB=$(md5sum /etc/hosts.block | sed -e 's/\ .\/etc\/hosts.*//');
	
	echo
	echo \"$HOST\"  hosts \(current\)
	echo \"$HOSTU\" hosts.unblock
	echo \"$HOSTB\" hosts.block
	echo
}


banner;

BLOCK="/etc/hosts.block"

if [ -f $BLOCK ]
        then
		
        echo $BLOCK found, swapping hosts
		
		#Checking currently used hosts file
		hostsMD5

		#Set system as rewritable
		busybox mount -o remount,rw -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		if [ "$HOST" == "$HOSTU" ] ; then
		   cp /etc/hosts.block /etc/hosts
		   echo "------------------Ads now blocked---------------------"
		else
		   cp /etc/hosts.unblock /etc/hosts
		   echo "-----------------Ads now unblocked--------------------"
		fi

		#Checking hosts file again to verify it has been switched
		hostsMD5
		
		#Set system as read-only
		busybox mount -o remount,ro -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

	else
		#Set system as rewritable
        busybox mount -o remount,rw -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system
		
		#Check sdcard folder for hosts.block file to use
		if [ -f "/sdcard/Hosts_swap/hosts.block" ]
			then
		                cp /etc/hosts /etc/hosts.unblock
						echo hosts.unblock file created
						
						#Create softlink to the 'block' hosts file on the sdcard
                		ln -sf /sdcard/Hosts_swap/hosts.block /etc/hosts.block
						echo hosts.block file has been copied
		else
				echo hosts.block file not found...
				exit
		fi

		#Set system as read-only
                busybox mount -o remount,ro -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		echo
		echo Hosts files have been setup, rerun this script to switch between the two
		echo
fi

exit 0
