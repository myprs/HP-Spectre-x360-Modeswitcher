#!/bin/sh

## this is a touchpad script for the HP spectre x360 convertible mode switcher
## this script just logs the action taken to the syslog faciliy


[ -r /etc/default/hp-spectre-x360 ] && source /etc/default/hp-spectre-x360


if [ -z "$TOUCHDEV" ];
then
	# please set the device name of the touchpad statically in the defaults file to 
	# prevent detection multiple times on each mode change
	TOUCHDEV=`xinput  --list --name-only | grep -i touchpad`
	[ `echo "$TOUCHDEV"|wc -l` -ne 1 ] && { logger -t "HP-spectre-x360-mode-switch" "ERROR: autodetection of touchpad failed."; send-; exit 1; }
fi

case $1 in 
	"laptop")
		xinput --enable "$TOUCHDEV"
	;;
	"tablet")
		xinput --disable "$TOUCHDEV"
	;;
	*)
		logger -t "HP-spectre-x360-modeswitch" "ERROR: Mode Switcher was calles with unknown parameter: \"$0\" in \$0."
	;;
esac

