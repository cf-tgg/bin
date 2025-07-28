#!/bin/bash
# batchimgs : Batch images for processing

# Variables
IMGDIR="$1"                # Source directory for images
TMP="temp"                 # Final directory for grouped images
tmp_dir=$(mktemp -d)       # Temporary directory for initial renaming
BSIZE="${BSIZE:-100}"      # batch size if not set as an environment variable
RES="${2:-1920x1080}"      # resolution for images

# Validate input
if [[ -z "$IMGDIR" || ! -d "$IMGDIR" ]]; then
  echo "Usage: $0 <source_directory>"
  exit 1
fi

# Find and sort images by natural order
IMGS=($(ls -v "$IMGDIR"/*.{jpg,jpeg,png,gif} 2>/dev/null))
total_images=${#IMGS[@]}
pad=${#total_images}

# Step 1: Preprocess and rename images in the temporary directory
echo "Preprocessing images..."
counter=1
for image in "${IMGS[@]}"; do
  ext="${image##*.}"
  magick "$image" \
    -resize ${RES}\> \
    -auto-orient \
    -gravity center \
    -background black \
    -quality 100 \
    -extent ${RES} \
    "$tmp_dir/$(printf "%0${pad}d.%s" "$counter" "$ext")"
  printf "%s/%s\r" "$counter" "$total_images"
  ((counter++))
done
wait
echo "Preprocessing complete."

# Check if images exceed the batch size
if (( total_images <= BSIZE )); then
  echo "Total images ($total_images) do not exceed the batch size ($BSIZE). No grouping needed."
  mv "$tmp_dir" "$TMP"
  exit 0
fi

# Calculate the number of groups needed
ngroups=$(( (total_images + BSIZE - 1) / BSIZE ))

# Split into batches and move to the final directory
mkdir -p "$TMP"  # Ensure the target temp directory exists
for (( i = 0; i < ngroups; i++ )); do
  BATCHDIR="${TMP}/$((i + 1))"
  mkdir -p "$BATCHDIR"

  # Calculate start and end indices for the group
  start_idx=$(( i * BSIZE ))
  end_idx=$(( (i + 1) * BSIZE - 1 ))
  if (( end_idx >= total_images )); then
    end_idx=$(( total_images - 1 ))
  fi

  # Move images in this group to the group directory
  for (( j = start_idx; j <= end_idx; j++ )); do
    img="${tmp_dir}/$(printf "%0${pad}d.%s" $((j + 1)) "${IMGS[j]##*.}")"
    mv "$img" "${BATCHDIR}/$(basename "$img")"
    printf "Grouping images into batches... %s/%s\r" "$((j + 1))" "$ngroups"
  done
done
wait
echo "Grouping complete. $ngroups batches created."

echo "Cleaning up temporary files..."
rm -r "$tmp_dir"
echo "Done."
echo "Preprocessed images moved to '$TMP'."
