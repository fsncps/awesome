#!/bin/bash

# Delay to allow screens to settle
sleep 1

# Start WezTerm on screen 2 first
wezterm &

# Small delay to ensure order
sleep 0.5

# Start second WezTerm window (goes to screen 1)
wezterm cli spawn --new-window &

# Launch Librewolf and Dolphin (tiled on 1080p)
librewolf &
dolphin &
