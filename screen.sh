#!/bin/sh

# Set DPI globally to 144 (for 4K)
echo "Xft.dpi: 144" | xrdb -merge

# Configure screen layout
xrandr \
   --output HDMI-0 --mode 1920x1080 --pos -540x0 --scale 1.5x1.5 --rotate left \
   --output DVI-D-0 --mode 3840x2160 --pos 1080x0 --rotate normal \
   --output DP-0 --primary --mode 3840x2160 --pos 4920x0 --rotate normal \
   --output DP-1 --off
