#!/bin/sh

## This is a script for the HP spectre x360 convertible mode switcher.
## This script flips the screen into the configured orientation in tablet mode.

DEBUG=${DEBUG:-0}
XRANDR_DISPLAYNAME="eDP1"
XRANDR_LPTP_ROTATION="normal"
XRANDR_TBLT_ROTATION="inverted"

[ -r /etc/default/hp-spectre-x360 ] && . /etc/default/hp-spectre-x360



case $1 in 
	"laptop")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Laptop\": Setting display $XRANDR_DISPLAYNAME rotation to $XRANDR_LPTP_ROTATION."
		xrandr --output "$XRANDR_DISPLAYNAME" --rotate "$XRANDR_LPTP_ROTATION"
	;;
	"tablet")
		[ $DEBUG -ge 1 ] && logger -t "HP-spectre-x360-modeswitch" "Switching to mode \"Tablet\": Setting display $XRANDR_DISPLAYNAME rotation to $XRANDR_TBLT_ROTATION."
		xrandr --output "$XRANDR_DISPLAYNAME" --rotate "$XRANDR_TBLT_ROTATION"
	;;
	*)
		logger -t "HP-spectre-x360-x360-modeswitch" "ERROR: Mode Switcher was calles with unknown parameter: \"$0\" in \$0."
	;;
esac

