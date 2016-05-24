#!/bin/sh

## this is a template script for the HP spectre x360 convertible mode switcher
## this script just logs the action taken to the syslog faciliy


[ -r /etc/default/hp-spectre-x360 ] && source /etc/default/hp-spectre-x360

case $1 in 
	"laptop")
		logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\"."
		notify-send "HP-spectre-x360-modeswitch" "Now in Mode \"$1\""
	;;
	"tablet")
		logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Tablet\"."
		notify-send "HP-spectre-x360-modeswitch" "Now in Mode \"$1\""
	;;
	*)
		logger -t "HP-spectre-x360-modeswitch" "ERROR: Mode Switcher was calles with unknown parameter: \"$0\" in \$0."
		notify-send "HP-spectre-x360-modeswitch" "ERROR: unknown  Mode \"$1\""
	;;
esac

