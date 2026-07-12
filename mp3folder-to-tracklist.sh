#!/bin/bash

# Seconds to add between consecutive tracks.
# Set to 0 if you do not want to add pauses.
PAUSE=1

# Use the folder provided as an argument,
# or the current folder if none is provided.
FOLDER="${1:-.}"

OUTPUT="$FOLDER/tracklist.txt"
total_time=0

# Clear the output file.
> "$OUTPUT"

format_time() {
    local total=$1
    local hours=$((total / 3600))
    local minutes=$(((total % 3600) / 60))
    local seconds=$((total % 60))

    if (( hours > 0 )); then
        printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds"
    else
        printf "%02d:%02d" "$minutes" "$seconds"
    fi
}

# Read MP3 files in alphabetical order.
# Names starting with 01, 02, 03... preserve the track order.
while IFS= read -r -d '' file; do

    name=$(basename "$file" .mp3)

    # Remove the leading track number, for example:
    # "01 - First track" -> "First track"
    title=$(printf '%s' "$name" | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*[-–—._)][[:space:]]*//')

    timestamp=$(format_time "$total_time")
    printf "%s - %s\n" "$timestamp" "$title" >> "$OUTPUT"

    # afinfo returns the duration in seconds, including decimal values.
    duration=$(afinfo "$file" |
        awk -F': ' '/estimated duration/ {
            printf "%.0f", $2
            exit
        }')

    if [[ -z "$duration" ]]; then
        echo "Error: unable to read the duration of $file" >&2
        exit 1
    fi

    total_time=$((total_time + duration + PAUSE))

done < <(
    find "$FOLDER" -maxdepth 1 -type f \
        \( -iname "*.mp3" \) \
        -print0 |
    sort -z
)

echo "Tracklist generated: $OUTPUT"
