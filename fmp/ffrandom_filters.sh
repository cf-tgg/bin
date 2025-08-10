#!/bin/bash

# Define the input videos
input_videos=("1.mp4" "2.mp4" "3.mp4" "4.mp4")

# Define an array of random effects
effects=(
    "fade=t=in:st=0:d=2"
    "crop=iw/2:ih/2"
    "hue=s=0"      # Grayscale
    "negate"       # Invert colors
    "eq=contrast=1.5" # Increase contrast
)

# Create the filter complex string
filter_complex=""

# Loop through each input video and randomly select an effect
for i in "${!input_videos[@]}"; do
    # Randomly select an effect
    random_effect=${effects[RANDOM % ${#effects[@]}]}

    # Build the filter complex
    if [ $i -eq 0 ]; then
        filter_complex="[${i}:v]${random_effect}[v${i}];"
    else
        filter_complex="${filter_complex}[${i}:v]${random_effect}[v${i}];"
    fi
done

# Add stacking commands
filter_complex="${filter_complex} \
[v0][v1]hstack=inputs=2[top]; \
[v2][v3]hstack=inputs=2[bottom]; \
[top][bottom]vstack=inputs=2"

# Run the ffmpeg command
ffmpeg -i "${input_videos[0]}" -i "${input_videos[1]}" -i "${input_videos[2]}" -i "${input_videos[3]}" \
-filter_complex "$filter_complex" -c:v libx264 -crf 23 -preset veryfast output.mp4
