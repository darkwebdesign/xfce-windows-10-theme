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

#
# @TODO create extended panel on other monitors (does this work when extended monitor is turned off?)
#

# Declare variables
declare scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
declare repositoryPath="$(dirname "$scriptPath")";

declare -a connectedOutputs=($(xrandr | awk '/ connected (primary )?[1-9]+/ { print $1; }'));
declare primaryOutput="${connectedOutputs[0]}";
if [[ ${#connectedOutputs[@]} -gt 1 ]]; then
    primaryOutput=$(xrandr | awk '/ connected primary [1-9]+/ { print $1; }');
fi;

declare -a primaryOutputProperties=($(xrandr | awk "/$primaryOutput connected (primary )?[1-9]+/ { match(\$0, /([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)/, a); print a[1], a[2], a[3], a[4]; }"));
declare -i primaryOutputWidth="${primaryOutputProperties[0]}";
declare -i primaryOutputHeight="${primaryOutputProperties[1]}";
declare -i primaryOutputOffsetX="${primaryOutputProperties[2]}";
declare -i primaryOutputOffsetY="${primaryOutputProperties[3]}";

declare -i positionX=$(($primaryOutputOffsetX + $primaryOutputWidth / 2));
declare -i positionY=$(($primaryOutputOffsetY + $primaryOutputHeight - 13));

# Remove panel files
rm --recursive ~/.config/xfce4/panel/* &> /dev/null;

# Remove all panels
xfconf-query --channel 'xfce4-panel' --property '/panels' --reset --recursive;

# Remove all plugins
xfconf-query --channel 'xfce4-panel' --property '/plugins' --reset --recursive;

# Create panel
xfconf-query --channel 'xfce4-panel' --property '/panels' --create --type 'int' --set 1;

# Restart panels
xfce4-panel --restart && sleep 1;

# Configure panel
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/background-alpha' --create --type 'int' --set 100;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/background-color' --create --type 'uint' --set 0 --type 'uint' --set 8995 --type 'uint' --set 15934 --type 'uint' --set 65535; # #00233E
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/background-image' --create --type 'string' --set '';
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/background-style' --create --type 'int' --set 1; # Solid color
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/enter-opacity' --create --type 'int' --set 100;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/leave-opacity' --create --type 'int' --set 100;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/disable-struts' --create --type 'bool' --set false;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/length' --create --type 'int' --set 100;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/length-adjust' --create --type 'bool' --set true;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/mode' --create --type 'int' --set 0;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/plugin-ids' --create --type 'int' --set 1 --type 'int' --set 2 --type 'int' --set 3 --type 'int' --set 4 --type 'int' --set 5 --type 'int' --set 6 --type 'int' --set 7 --type 'int' --set 8 --type 'int' --set 9;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/position' --create --type 'string' --set "p=8;x=$positionX;y=$positionY";
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/position-locked' --create --type 'bool' --set true;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/size' --create --type 'int' --set 30;
xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/span-monitors' --create --type 'bool' --set false;

# Add panel plugins
xfce4-panel --add 'whiskermenu';
xfce4-panel --add 'showdesktop';
xfce4-panel --add 'launcher';
xfce4-panel --add 'launcher';
xfce4-panel --add 'separator';
xfce4-panel --add 'tasklist';
xfce4-panel --add 'separator';
xfce4-panel --add 'systray';
xfce4-panel --add 'power-manager-plugin';
xfce4-panel --add 'indicator';
xfce4-panel --add 'separator';
xfce4-panel --add 'clock';

# Configure plugin Separator
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-5/style' --create --type 'int' --set 0; # Transparent
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-7/expand' --create --type 'bool' --set true;
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-7/style' --create --type 'int' --set 0; # Transparent
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-11/style' --create --type 'int' --set 0; # Transparent

# Configure plugin Launcher
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-3/items' --create --type 'string' --set 'exo-web-browser.desktop' --force-array;
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-4/items' --create --type 'string' --set 'exo-file-manager.desktop' --force-array;

# Configure plugin Window Buttons
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-6/flat-buttons' --create --type 'bool' --set true;
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-6/include-all-monitors' --create --type 'bool' --set false;
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-6/show-handle' --create --type 'bool' --set false;

# Configure plugin Notification Area
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-8/names-visible' --create --type 'string' --set 'network' --type 'string' --set 'gigolo' --type 'string' --set 'blueman-applet' --type 'string' --set 'thunar' --type 'string' --set 'notes';
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-8/show-frame' --create --type 'bool' --set false;
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-8/size-max' --create --type 'int' --set 22;

# Configure plugin Indicator Plugin
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-10/blacklist' --create --type 'string' --set 'libappmenu.so' --force-array;
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-10/known-indicators' --create --type 'string' --set 'libapplication.so' --type 'string' --set 'com.canonical.indicator.sound' --type 'string' --set 'com.canonical.indicator.messages';

# Configure plugin Clock
xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-12/digital-format' --create --type 'string' --set '%H:%M';

# Write Whisker Menu config file
echo "button-title=Start
button-icon=$repositoryPath/dist/panel/start.png
show-button-title=true
show-button-icon=true" > ~/.config/xfce4/panel/whiskermenu-1.rc;

# Write Web Browser launcher
mkdir --parents ~/.config/xfce4/panel/launcher-3;
cp /usr/share/applications/exo-web-browser.desktop ~/.config/xfce4/panel/launcher-3/exo-web-browser.desktop;

# Write File Manager launcher
mkdir --parents ~/.config/xfce4/panel/launcher-4;
cp /usr/share/applications/exo-file-manager.desktop ~/.config/xfce4/panel/launcher-4/exo-file-manager.desktop;

# Restart panels
xfce4-panel --restart && sleep 1;
