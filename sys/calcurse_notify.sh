#!/bin/bash

# Get the next event from calcurse
next_event=$(calcurse --list | awk '
BEGIN { RS = "\n"; FS = "\t"; date = ""; time = ""; title = "" }
/^-/ {
    if ($0 ~ /^\//) {
        print $0;
        exit;
    } else {
        date = $0;
    }
}
/^-\s[0-9]{2}:[0-9]{2}-[0-9]{2}/ {
    time = $0;
}
/^-\s[0-9]{2}:[0-9]{2}-[0-9]{2}\t/ {
    title = substr($0, index($0, ") + 1);
    print date, time, title;
    exit;
}' | head -n 1)

# Check if there's a next event
if [ -z "$next_event" ]; then
    echo "No upcoming appointments."
else
    # Format the notification content
    subject="Upcoming Appointment"
    body="Date: ${next_event%% *}\nTime: ${next_event##* -
}\nTitle: ${next_event##* - ##* - }\n"

    # Display the notification
    notify-send "$subject" $body"
fi

calcurse --next | notify-send -
calcurse --next | piper -m fr_FR-gilles-low -
