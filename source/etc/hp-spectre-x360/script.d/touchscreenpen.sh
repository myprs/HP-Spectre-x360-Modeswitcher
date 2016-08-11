#!/bin/sh

## This is a touchscreen pen support script for the HP spectre x360 convertible mode switcher.
## This script turns the orientation according to the display orientation.

DEBUG=${DEBUG:-0}
[ -r /etc/default/hp-spectre-x360 ] && .  /etc/default/hp-spectre-x360

if [ -z "$TOUCHPENDEVID" ] ;
then
	# please set the device ID or the device name of the touchscreen statically in the defaults file to 
	# prevent detection multiple times on each mode change

	if [ -z "$TOUCHPENSCREEN" ];
	then
		TOUCHPENSCREEN=`xinput  --list --name-only | grep -i touchscreen | grep -i pen`
		[ `echo "$TOUCHPENSCREEN"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchscreen pen support failed."; send-; exit 1; }
	fi

	# get device numeric ID
	TOUCHPENDEVID=`xinput list --id-only "$TOUCHPENSCREEN"`
	[ `echo "$TOUCHPENDEVID"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchscreen pen support numeric device ID failed."; send-; exit 2; }
fi

if [ -z "$TOUCHPENPROPINVID" ];
then 
	# please set the device ID or the device name of the touchscreen statically in the defaults file to 
	# prevent detection multiple times on each mode change
	
	# get property ID
	TOUCHPENPROPINVID=`xinput list-props $TOUCHPENDEVID | grep -i "Axis Inversion" | mawk -F '(' '{ print $2 }' | mawk -F ')' '{ print $1 }'`
	[ `echo "$TOUCHPENPROPINVID"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchscreen pen support property \"Axis Inversion\" failed."; send-; exit 3; }
fi


case $1 in 
	"laptop")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchscreen pen support \"$TOUCHPENSCREEN\" (TOUCHPENDEVID $TOUCHPENDEVID) to xx-lap ."
		xinput set-prop $TOUCHPENDEVID  $TOUCHPENPROPINVID 0 0
	;;
	"tablet")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchscreen pen support \"$TOUCHPENSCREEN\" (TOUCHPENDEVID $TOUCHPENDEVID) to xx-lap ."
		xinput set-prop $TOUCHPENDEVID  $TOUCHPENPROPINVID 1 1
	;;
	*)
		logger -t "HP-spectre-x360-modeswitch" "ERROR: Mode Switcher was calles with unknown parameter: \"$0\" in \$0."
	;;
esac

