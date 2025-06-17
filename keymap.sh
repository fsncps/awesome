#!/bin/bash

# Apply XKB shift-shift for caps first
setxkbmap -option shift:both_capslock

# Clean out any existing bindings
xmodmap -e "clear Mod3"
xmodmap -e "clear Mod4"
xmodmap -e "clear Lock"

xmodmap -e "remove Mod3 = Hyper_L"
xmodmap -e "remove Mod4 = Super_L"
xmodmap -e "remove Mod1 = Super_L"
xmodmap -e "remove Mod2 = Super_L"
xmodmap -e "remove Mod5 = Super_L"

# Explicitly remap keycodes (confirm keycodes 66 and 133 via xev)
xmodmap -e "keycode 66 = Super_L"
xmodmap -e "keycode 133 = Hyper_L"

# Now add them cleanly
xmodmap -e "add Mod4 = Super_L"
xmodmap -e "add Mod3 = Hyper_L"
