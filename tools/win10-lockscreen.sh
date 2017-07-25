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

if [[ "$UID" -ne 0 ]]; then
    echo "${0##*/}: requires root permissions!";
    exit 1;
fi;

# Declare variables
declare scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
declare repositoryPath="$(dirname "$scriptPath")";

# Write LightDM GTK+ Greeter config file
echo "[greeter]
background = $repositoryPath/lockscreens/img100.jpg
indicators =
user-background = false" > /etc/lightdm/lightdm-gtk-greeter.conf;
