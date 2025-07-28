#!/bin/bash

LST=($(ls -1 *.jpg))
TOT=${#LST[*]}
f="${LST[0]}"

INP=("-loop" "1" "-t" "6" "-i" "$f")  # Start with 6 seconds for the first image
PDX="[0]"  # Initial input label for the first image
FLX=""     # Filter chain for crossfades
OFS=5      # Offset start time for the first transition

# Add each image to the input list and apply crossfade filters
for (( i=1; i<TOT; i++ )); do
  f="${LST[$i]}"
  # If it's the last image, extend the duration by 1 second
  if [[ $i -eq $((TOT - 1)) ]]; then
    INP+=("-loop" "1" "-t" "7" "-i" "$f")  # Last image will be shown for 7 seconds
  else
    INP+=("-loop" "1" "-t" "6" "-i" "$f")  # Other images will be shown for 6 seconds
  fi

  # Set up crossfade filter between the current pair of images
  FLX+="${PDX}[${i}]xfade=transition=fade:duration=1:offset=${OFS}[xf${i}];"

  # Update PDX to the output of the last xfade for the next loop
  PDX="[xf${i}]"
  ((OFS += 5))
done

# Final output
echo "$FLX"
echo ""
rm -f /tmp/output.mp4

ffmpeg "${INP[@]}" -filter_complex "${FLX%?}" -map "${PDX}" -c:v libx264 -crf 20 -y output.mp4 -hide_banner
