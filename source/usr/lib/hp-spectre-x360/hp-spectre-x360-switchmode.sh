#!/bin/bash -xv

[ -r /etc/default/hp-spectre-x360 ] && source /etc/default/hp-spectre-x360



function usage () {

cat <<EOUSAGE

usage: hp-spectre-switchmode help|laptop|tablet


EOUSAGE

}


QUEUEFILE="/var/run/hp-spectre-x360-modewitch.queue"
QUEUETIMEOUT=5 	# timeout in seconds after that the queue gets fishy and should be reorganised. We assume that the first in queue died and does not leave the queeu.
		# so we throw away all the queue. Evey provess had to be able to detect if he has been thrown out of the queu and just requeu.
SLEEPTIME=0.05
MODEFILE="/var/run/hp-spectre-x360.mode"


function enter_queue () {

	# add my processnumber to the end of the queue file
	echo "$$" >>"$QUEUEFILE"

	# am I first?
	local HEADOFQUEUE=`head -n 1 "$QUEUEFILE"`
	local HEADOFQUEUESTARTWAIT=`date +%s`
	local NEWHEADOFQUEUE

	while [ "$HEADOFQUEUE" != "$$" ] ;
	do 
		# be patient 
		sleep $SLEEPTIME

		# has the head of the queue changed?
		NEWHEADOFQUEUE=`head -n 1 "$QUEUEFILE"`
		if [ $HEADOFQUEUE -ne $NEWHEADOFQUEUE ] ;
		then
			# yes it has
			HEADOFQUEUE=$NEWHEADOFQUEUE
			HEADOFQUEUESTARTWAIT=`date +%s`
		else
			# no it hasn't
	
			# is the queue stale?
			WAITTIME=$((`date +%s` - $HEADOFQUEUESTARTWAIT))
			if [ $WAITTIME -ge $QUEUETIMEOUT ] ; 
			then 
				# yes, please reorganise! And we do take the chance ;-)
				echo "$$" >"$QUEUEFILE"
		
				sleep $SLEEPTIME $SLEEPTIME
				HEADOFQUEUE=`head -n 1 "$QUEUEFILE"`
				HEADOFQUEUESTARTWAIT=`date +%s`
			fi

			# am I stil in queue?
			grep "$$" "$QUEUEFILE" >/dev/null
			if [ $? -ne 0 ] ;
			then
				# add me to the queue again
				echo "$$" >>"$QUEUEFILE"#
			fi
		fi
	done			

}


function leave_queue () {

	# filter me out of the queue into a temporary queue file
	grep -v "$$" "$QUEUEFILE" >"$QUEUEFILE.tmp.$$"

	# exchange the files
	mv "$QUEUEFILE.tmp.$$" "$QUEUEFILE"


}

function check_mode () {


	# This function checks if the laptop already is in the requested state.
	# This is to prevent the case that one flip action issues multiple events.
	# on the other hand, if the state is too old it might be untrue as events 
	# cannot be tracked during hibernation or power off
	
	# if the state file does not exist, create an empty one
	[ ! -f "$MODEFILE" ] && touch "$MODEFILE" 


	# is statefile too old? (last change older that 3 seconds)
	test `find "$MODEFILE" -not -newermt '-3 seconds'`  && echo "">"$MODEFILE"
	

	grep "$MODE" "$MODEFILE" >/dev/null
	if [ $? -eq 0 ]; 
	then
		# our mode is set and the modefile was not too old
		# we do not need to chacnge the  mode
		return 1
	fi
	return 0

	
}


function do_switchmode () {

	# entering the queue
	enter_queue

	# coming out of the enter_queue function means that it is my turn!

	# do i need to switch mode?
	## results out of keycodes being fired multiple times on one switching event
	## distrust stale state files, as mode changes during power off os hibernation cannot be detected
	check_mode
		
	if [ $? -eq 0 ];
	then	
		#### yes: do the switch!
		run-parts --arg="$MODE" /etc/hp-spectre-x360/"$MODE"-mode/

		#### yes: set the mode!
		echo "$MODE">"$MODEFILE"
	fi

	# unqueue
	leave_queue

}

[ -z "$1" ] && { usage; exit 1; }
MODE="$1"

case "$1" in
	"laptop")
		do_switchmode "$1"
	;;
	"tablet")
		do_switchmode "$1"
	;;
	"help")
		usage
		exit 0
	;;
	*)
		echo "ERROR: unknown parameter in call. Please se usage below. Aborting."
		usage
		exit 2
	;;
esac

