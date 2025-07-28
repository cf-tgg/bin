#!/usr/bin/zsh

NEXTA=($(calcurse --next))
TIME_UNTIL="$(echo $NEXTA | awk '{ print $3 }')"

# echo "NEXTA: " $NEXTA
# echo "TIME_UNTIL: " $TIME_UNTIL

RDV=()

 for i in {4..${#NEXTA}}; do
	RDV+=$NEXTA[i]
 done

HEURES=$(echo $TIME_UNTIL | tr -d '[]' | cut -d ':' -f1)
MINUTES=$(echo $TIME_UNTIL | tr -d '[]' | cut -d ':' -f2)

NOTIFY_STR=$(echo "$RDV dans $(printf '%d' $HEURES) heures $(printf '%d' $MINUTES) minutes.")
CALNOTIFY=$(echo "$RDV dans $(printf '%d' $MINUTES) minutes.")

if [ "$1" = '-m' ]; then
	notify-send "$RDV" -t 120000
	echo $CALNOTIFY
else
	echo "$NOTIFY_STR"
	tts -m fr_FR-gilles-low "$NOTIFY_STR"
fi

exit 0
