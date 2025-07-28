#!/bin/sh

# Extract the output of calcurse --next into a variable
NEXTA=$(calcurse --next)

# Extract the time [HH:MM] from the output
TIME_UNTIL=$(echo "$NEXTA" | awk '{ print $3 }')

# Display the raw output and the extracted time
echo "NEXTA: $NEXTA"
echo "TIME_UNTIL: $TIME_UNTIL"

# Initialize an empty string for the appointment details
RDV=""

# Extract the appointment details starting from the 4th word
# Using awk to handle splitting and joining fields
RDV=$(echo "$NEXTA" | awk '{for (i=4; i<=NF; i++) printf "%s ", $i; print ""}')

# Display the appointment details
echo "Appointment: $RDV"

# Strip the square brackets and split the time into minutes and seconds
HEURE=$(echo "$TIME_UNTIL" | tr -d '[]' | cut -d ':' -f1)
MIN=$(echo "$TIME_UNTIL" | tr -d '[]' | cut -d ':' -f2)

# Remove leading zeros using arithmetic evaluation
# In POSIX sh, the `expr` command is used to handle numeric operations
HEURES=$(printf "%d" "$HEURE")
MINUTES=$(printf "%d" "$MIN")

# Display minutes and seconds without leading zeros
echo "$RDV dans $HEURES heures $MINUTES minutes"

