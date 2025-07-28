#!/usr/bin/bash

# Extract the output of calcurse --next into an array
NEXTA=($(calcurse --next))
# Extract the time [HH:MM] from the output
TIME_UNTIL="$(echo ${NEXTA[2]})"
echo "NEXTA: ${NEXTA[*]}"
echo "TIME_UNTIL: $TIME_UNTIL"
# Initialize an empty string for the appointment details
RDV=""
# Loop over the array starting from the 4th element to capture the appointment name
for i in $(seq 3 $((${#NEXTA[@]}-1))); do     RDV="$RDV ${NEXTA[i]}"; done
echo "Appointment: $RDV"
# Strip the square brackets and split the time into minutes and seconds
MIN=$(echo $TIME_UNTIL | tr -d '[]' | cut -d ':' -f1)
SEC=$(echo $TIME_UNTIL | tr -d '[]' | cut -d ':' -f2)
# Remove leading zeros using arithmetic evaluation
MIN=$((10#$MIN))
SEC=$((10#$SEC))
echo $MIN
echo $RDV
echo $SEC
