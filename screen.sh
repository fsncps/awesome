#!/bin/sh

xrdb -merge <<< "Xft.dpi: 144"

# Skip if layout already applied
if ! xrandr --listmonitors | grep -q DP-0; then
  exit
fi

xrandr \
  --output DP-0 --off \
  --output DVI-D-0 --off \
  --output HDMI-0 --off

xrandr \
  --output DP-0 --primary --mode 3840x2160 --pos 3840x0 --rotate normal \
  --output DVI-D-0 --mode 3840x2160 --pos 0x0 --rotate normal \
  --output HDMI-0 --mode 1920x1080 --scale 1.5x1.5 --pos 7680x200 --rotate normal

