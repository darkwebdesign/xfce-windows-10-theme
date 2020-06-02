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

# Declare constants
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
readonly DIST_LOCKSCREENS_DIRECTORY="$DIR/../dist/lockscreens";
readonly UBUNTU_BACKGROUNDS_DIRECTORY='/usr/share/backgrounds';
readonly BACKGROUND_FILE_NAME_PREFIX='win10-';
readonly LOCKSCREEN_FILE="$XFCE_LOCKSCREENS_DIRECTORY/img100.jpg";
readonly LIGHTDM_GTK_GREETER_CONFIG_FILE='/etc/lightdm/lightdm-gtk-greeter.conf';

# Copy lockscreens with prefix
ls "$DIST_LOCKSCREENS_DIRECTORY" | xargs --replace cp "$DIST_LOCKSCREENS_DIRECTORY/{}" "$UBUNTU_BACKGROUNDS_DIRECTORY/$BACKGROUND_FILE_NAME_PREFIX{}";

# Write LightDM GTK+ Greeter config file
echo "[greeter]
background = $LOCKSCREEN_FILE
indicators =
user-background = false" > "$LIGHTDM_GTK_GREETER_CONFIG_FILE";
