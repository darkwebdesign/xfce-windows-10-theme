#!/usr/bin/env bash

# Configure <Win> to open Whisker Menu popup
#xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/Super_L' --create --type 'string' --set 'xfce4-popup-whiskermenu';

# Configure <Win+E> to open File Manager
xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Super>e' --create --type 'string' --set 'exo-open --launch FileManager --working-directory .';

# Configure <Win+F> to open Application Finder
xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Super>f' --create --type 'string' --set 'xfce4-appfinder';

# Configure <Win+L> to lock the screen
xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Super>l' --create --type 'string' --set 'xflock4';

# Configure <Ctrl+Shift+Esc> to open System Monitor
xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Primary><Shift>Escape' --create --type 'string' --set 'gnome-system-monitor';
