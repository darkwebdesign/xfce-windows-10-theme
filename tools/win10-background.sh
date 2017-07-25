#!/usr/bin/env bash

##
# Copyright (c) 2017 DarkWeb Design
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

# Declare variables
declare scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
declare repositoryPath="$(dirname "$scriptPath")";
declare backgroundPath="$repositoryPath/wallpapers/img0.jpg";

declare -a connectedOutputs=($(xrandr | awk '/ connected (primary )?[1-9]+/ { print $1; }'));

# Remove backdrop configuration
xfconf-query --channel 'xfce4-desktop' --property '/backdrop' --reset --recursive;

# Configure backdrop
xfconf-query --channel 'xfce4-desktop' --property '/backdrop/single-workspace-mode' --create --type 'bool' --set true;

# Configure backdrop for workspaces
xfconf-query --channel 'xfce4-desktop' --property '/backdrop/screen0/monitor0/workspace0/last-image' --create --type 'string' --set "$backgroundPath";
xfconf-query --channel 'xfce4-desktop' --property '/backdrop/screen0/monitor0/workspace0/image-show' --create --type 'bool' --set true;
xfconf-query --channel 'xfce4-desktop' --property '/backdrop/screen0/monitor0/workspace0/image-style' --create --type 'int' --set 5; # Zoomed

# Configure backdrop per connected monitor
for ((i = 0; i <= ${#connectedOutputs[@]}; i++)); do
    xfconf-query --channel 'xfce4-desktop' --property "/backdrop/screen0/monitor$i/image-path" --create --type 'string' --set "$backgroundPath";
    xfconf-query --channel 'xfce4-desktop' --property "/backdrop/screen0/monitor$i/image-show" --create --type 'bool' --set true;
    xfconf-query --channel 'xfce4-desktop' --property "/backdrop/screen0/monitor$i/image-style" --create --type 'int' --set 5; # Zoomed
done;

# Configure backdrop per connected output
for connectedOutput in "${connectedOutputs[@]}"; do
    xfconf-query --channel 'xfce4-desktop' --property "/backdrop/screen0/monitor$connectedOutput/workspace0/last-image" --create --type 'string' --set "$backgroundPath";
    xfconf-query --channel 'xfce4-desktop' --property "/backdrop/screen0/monitor$connectedOutput/workspace0/image-show" --create --type 'bool' --set true;
    xfconf-query --channel 'xfce4-desktop' --property "/backdrop/screen0/monitor$connectedOutput/workspace0/image-style" --create --type 'int' --set 5; # Zoomed
done;
