#!/bin/bash

#Alex OConnor
#Install script to setup hosts files to use with Hosts_swap.sh

BLOCK="/etc/hosts.block"

if [ -f $BLOCK ]
	then
		echo $BLOCK found
		echo Hosts already setup
	else
		busybox mount -o remount,rw -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		cp /etc/hosts /etc/hosts.unblock
		cp /sdcard/hosts.block /etc/hosts.block

		busybox mount -o remount,ro -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system

		clear
		echo Hosts files have been setup, run swap script to change hosts file
		echo
fi

exit
