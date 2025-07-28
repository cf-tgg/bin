#!/bin/sh

CONNCOUNT=$(xrandr | grep -c ' connected')
DPI=384
LAYOUT_FILE="$HOME/.screenlayout/$(hostname).layout"
DISPLAYS=$(xrandr | grep ' connected' | awk '{print $1}')

# Function to check if a display is available
davail() {
    echo "$DISPLAYS" | grep -q "$1"
}

# Get connected displays with resolution and position
get_screens() {
    xrandr | grep ' connected' | awk '{if ($3 == "primary") {print $1, $4} else {print $1, $3}}'
}

# Save current layout to a file
save_layout() {
    > "$LAYOUT_FILE"
    get_screens | while read -r output res_pos; do
        res=$(echo "$res_pos" | cut -d'+' -f1)
        pos=$(echo "$res_pos" | cut -d'+' -f2)
        echo "$output $res $pos" >> "$LAYOUT_FILE"
    done
}

# Load layout from file
load_layout() {
    cat "$LAYOUT_FILE"
}

# Generate xrandr commands based on new layout
generate_xrandr_commands() {
    cmd="xrandr"
    primary_screen=""
    primary_width=0
    current_offset_x=0
    current_offset_y=0

    load_layout | while read -r output res pos; do
        if davail "$output"; then
            width=$(echo "$res" | cut -d'x' -f1)
            height=$(echo "$res" | cut -d'x' -f2)
            offset=$(echo "$pos" | cut -d'+' -f1)

            if [ "$primary_screen" = "" ]; then
                primary_screen="$output"
                primary_width=$width
                cmd="$cmd --output $output --mode ${width}x${height} --pos 0x0"
            else
                current_offset_x=$((current_offset_x + primary_width))
                cmd="$cmd --output $output --mode ${width}x${height} --pos ${current_offset_x}x${current_offset_y}"
            fi
        fi
    done

    echo "Generated xrandr command: $cmd"
    eval "$cmd"
}

# Layout configurations based on connected display count
layout_switch() {
    case "$CONNCOUNT" in
        1)
            # Single display configuration
            for display in $DISPLAYS; do
                case "$display" in
                    "eDP") generate_xrandr_commands "single_edp" && ACTIVE_LAYOUT="single_edp" ;;
                    "DisplayPort-2") generate_xrandr_commands "single_msi" && ACTIVE_LAYOUT="single_msi" ;;
                    "DisplayPort-1") generate_xrandr_commands "single_hp" && ACTIVE_LAYOUT="single_hp" ;;
                    *) generate_xrandr_commands "default_single" && ACTIVE_LAYOUT="default_single" ;;
                esac
            done
            ;;
        2)
            # Dual display configuration
            case "$ACTIVE_LAYOUT" in
                "single_edp"|"single_msi"|"single_hp") generate_xrandr_commands "duo1" && ACTIVE_LAYOUT="duo1" ;;
                "duo1") generate_xrandr_commands "duo2" && ACTIVE_LAYOUT="duo2" ;;
                "duo2") generate_xrandr_commands "duo3" && ACTIVE_LAYOUT="duo3" ;;
                *) generate_xrandr_commands "default_dual" && ACTIVE_LAYOUT="default_dual" ;;
            esac
            ;;
        3)
            # Triple display configuration
            case "$ACTIVE_LAYOUT" in
                "trio1") generate_xrandr_commands "trio2" && notify-send "T2" && ACTIVE_LAYOUT="trio2" ;;
                "trio2") generate_xrandr_commands "trio3" && notify-send "T3" && ACTIVE_LAYOUT="trio3" ;;
                "trio3") generate_xrandr_commands "trio4" && notify-send "T4" && ACTIVE_LAYOUT="trio4" ;;
                "trio4") generate_xrandr_commands "trio5" && notify-send "T5" && ACTIVE_LAYOUT="trio5" ;;
                "trio5") generate_xrandr_commands "trio6" && notify-send "T6" && ACTIVE_LAYOUT="trio6" ;;
                "trio6") generate_xrandr_commands "trio1" && notify-send "T1" && ACTIVE_LAYOUT="trio1" ;;
                *) generate_xrandr_commands "default_trio" && ACTIVE_LAYOUT="default_trio" ;;
            esac
            ;;
        *)
            echo "Unsupported display configuration."
            ;;
    esac
}

# Main
save_layout       # Save current layout for future use
layout_switch     # Apply the appropriate layout configuration
walfeh            # Restore wallpaper or other screen settings
echo "$ACTIVE_LAYOUT" > /tmp/dislayout
