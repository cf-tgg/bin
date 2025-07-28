#!/bin/sh

# Path to the battery capacity file
BATTERY_CAPACITY_FILE="/sys/class/power_supply/BAT1/capacity"
BATTERY_CYCLES_FILE="/sys/class/power_supply/BAT1/cycle_count"

# Get the current battery capacity
CURRENT_CAPACITY=$(cat $BATTERY_CAPACITY_FILE)
BATTERY_CYCLES=$(cat $BATTERY_CYCLES_FILE)

# Check if the capacity is below 30%
if [ "$CURRENT_CAPACITY" -lt "20" ]; then
    # Send a desktop notification
    notify-send "Moins de 20% d'batteries (${CURRENT_CAPACITY}) ..faut brancher la machine.. Bienvenue au ${BATTERY_CYCLES}e cycle.."
fi

echo "$CURRENT_CAPACITY"
