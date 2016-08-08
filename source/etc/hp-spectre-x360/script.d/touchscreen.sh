#!/bin/sh

## This is a touchscreen script for the HP spectre x360 convertible mode switcher.
## This script turns the orientation according to the display orientation.

DEBUG=${DEBUG:-0}
[ -r /etc/default/hp-spectre-x360 ] && .  /etc/default/hp-spectre-x360

if [ -z "$TOUCHDEVID" ] ;
then
	# please set the device ID or the device name of the touchscreen statically in the defaults file to 
	# prevent detection multiple times on each mode change

	if [ -z "$TOUCHSCREEN" ];
	then
		TOUCHSCREEN=`xinput  --list --name-only | grep -i touchscreen | grep -vi pen`
		[ `echo "$TOUCHSCREEN"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchscreen failed."; send-; exit 1; }
	fi

	# get device numeric ID
	TOUCHDEVID=`xinput list --id-only "$TOUCHSCREEN"`
	[ `echo "$TOUCHDEVID"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchscreen numeric device ID failed."; send-; exit 2; }
fi

if [ -z "$TOUCHPROPINVID" ];
then 
	# please set the device ID or the device name of the touchscreen statically in the defaults file to 
	# prevent detection multiple times on each mode change
	
	# get property ID
	TOUCHPROPINVID=`xinput list-props $TOUCHDEVID | grep -i "Axis Inversion" | mawk -F '(' '{ print $2 }' | mawk -F ')' '{ print $1 }'`
	[ `echo "$TOUCHPROPINVID"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchscreen property \"Axis Inversion\" failed."; send-; exit 3; }
fi


case $1 in 
	"laptop")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchscreen \"$TOUCHSCREEN\" (TOUCHDEVID $TOUCHDEVID) to laptop (Mode 0 0) ."
		xinput set-prop $TOUCHDEVID  $TOUCHPROPINVID 0 0
		RETVAL=$?
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchscreen \"$TOUCHSCREEN\" (TOUCHDEVID $TOUCHDEVID) to laptop (RETVAL=$RETVAL) ."
	;;
	"tablet")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchscreen \"$TOUCHSCREEN\" (TOUCHDEVID $TOUCHDEVID) to tablet (Mode 1 1) ."
		xinput set-prop $TOUCHDEVID  $TOUCHPROPINVID 1 1
		RETVAL=$?
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchscreen \"$TOUCHSCREEN\" (TOUCHDEVID $TOUCHDEVID) to tablet (RETVAL=$RETVAL) ."
	;;
	*)
		logger -t "HP-spectre-x360-modeswitch" "ERROR: Mode Switcher was calles with unknown parameter: \"$0\" in \$0."
	;;
esac

