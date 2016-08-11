#!/bin/sh

## This is a touchpad script for the HP spectre x360 convertible mode switcher
## This script switches the touhpad on and off.

DEBUG=${DEBUG:-0}
[ -r /etc/default/hp-spectre-x360 ] && .  /etc/default/hp-spectre-x360


if [ -z "$TOUCHDEV" ];
then
	# please set the device name of the touchpad statically in the defaults file to 
	# prevent detection multiple times on each mode change
	TOUCHDEV=`xinput  --list --name-only | grep -i touchpad`
	[ `echo "$TOUCHDEV"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchpad failed."; send-; exit 1; }
fi

case $1 in 
	"laptop")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchpad \"$TOUCHDEV\" to --enable ."
		xinput --enable "$TOUCHDEV"
	;;
	"tablet")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting Touchpad \"$TOUCHDEV\" to --disable ."
		xinput --disable "$TOUCHDEV"
	;;
	*)
		logger -t "HP-spectre-x360-modeswitch" "ERROR: Mode Switcher was calles with unknown parameter: \"$0\" in \$0."
	;;
esac

