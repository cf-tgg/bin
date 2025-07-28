#!/bin/bash

FIFO_PATH="/tmp/mpd_input.fifo"
[ -p "$FIFO_PATH" ] || mkfifo "$FIFO_PATH"

# parec -d bluez_output.F0_F6_C1_D1_B9_74.1.monitor -r | tee "$FIFO_PATH" >/dev/null &

arecord -D plughw:1,0 -f cd | tee "$FIFO_PATH" >/dev/null &
python3 /home/cf/.local/bin/mpd/mpd_voice_control.py
