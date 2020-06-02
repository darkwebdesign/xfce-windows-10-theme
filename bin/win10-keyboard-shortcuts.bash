#!/usr/bin/env bash

##
# Copyright (c) 2020 DarkWeb Design
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##

# Configure exit-on-error
set -e;

# Verify root permissions
if [[ "$UID" -ne 0 ]]; then
    echo "${0##*/}: requires root permissions!";
    exit 1;
fi;

# Configure <Win> to open Whisker Menu popup
#sudo xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/Super_L' --create --type 'string' --set 'xfce4-popup-whiskermenu';

# Configure <Win+E> to open File Manager
sudo xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Super>e' --create --type 'string' --set 'exo-open --launch FileManager --working-directory .';

# Configure <Win+F> to open Application Finder
sudo xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Super>f' --create --type 'string' --set 'xfce4-appfinder';

# Configure <Win+L> to lock the screen
sudo xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Super>l' --create --type 'string' --set 'xflock4';

# Configure <Ctrl+Shift+Esc> to open Task Manager
sudo xfconf-query --channel 'xfce4-keyboard-shortcuts' --property '/commands/custom/<Primary><Shift>Escape' --create --type 'string' --set 'xfce4-taskmanager';
