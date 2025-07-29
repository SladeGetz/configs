#!/bin/bash

export HYPRCTL=/usr/bin/hyprctl

function setMonitor() {
    $HYPRCTL keyword monitor "$1"
}

num_monitors="$( $HYPRCTL monitors | grep -c Monitor)"

# declare -a MONITORS=( \
#      ["3"]='DP-2,3840x2160@60,-2160x-600,1,transform,1 DP-4,3840x2160@60,0x0,1 DP-6,3840x2160@60,3840x-600,1,transform,3' \
#      ["2"]='DP-1,3840x2160@240,0x0,1 DP-2,3840x2160@60,-2160x-600,1,transform,1' \
#     )
declare -a MONITORS=( \
     ["3"]='keyword monitor DP-2,3840x2160@60,-2160x-600,1,transform,1 ; keyword monitor DP-4,3840x2160@60,0x0,1 ; keyword monitor DP-6,3840x2160@60,3840x-600,1,transform,3 ; hyprpaper wallpaper "DP-6,/home/slarch/.config/hypr/wallpaper/kv_main_pc08.jpg" ; hyprpaper wallpaper "DP-2,/home/slarch/.config/hypr/wallpaper/kv_main_pc08.jpg" ; hyprpaper wallpaper "DP-4,/home/slarch/.config/hypr/wallpaper/skull_knight.jpeg"  ' \
     ["2"]='keyword monitor DP-1,3840x2160@240,0x0,1 ; keyword monitor DP-2,3840x2160@60,-2160x-600,1,transform,1' \
    )


# if [[ "$num_monitors" -eq 3 ]]; then

#     setMonitor "

export -f setMonitor
export -f myEcho


$HYPRCTL --batch "${MONITORS[$num_monitors]}"

# echo "${MONITORS[$num_monitors]}" | tr ' ' '\n' | xargs -L1 bash -c 'setMonitor "$@"' _

# for key in "${!MONITORS[@]}"; do
#     echo "${MONITORS[$key]}" | tr ' ' '\n' | xargs -L1 echo
# done
