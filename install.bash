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
readonly TEMP_DIRECTORY="$(mktemp --directory)";
readonly GITHUB_VENDOR='darkwebdesign';
readonly GITHUB_PACKAGE='xfce-windows-10-theme';
readonly GITHUB_ARCHIVE_VERSION='master';
readonly GITHUB_ARCHIVE_FILENAME="$GITHUB_ARCHIVE_VERSION.zip";
readonly GITHUB_ARCHIVE_URI="https://github.com/$GITHUB_VENDOR/$GITHUB_PACKAGE/archive/$GITHUB_ARCHIVE_FILENAME";
readonly TEMP_ARCHIVE_FILE="$TEMP_DIRECTORY/$GITHUB_ARCHIVE_FILENAME";
readonly TEMP_BIN_DIRECTORY="$TEMP_DIRECTORY/$GITHUB_PACKAGE-$GITHUB_ARCHIVE_VERSION/bin";

# Download latest archive
echo 'Downloading latest archive from Github...';
curl --location --silent "$GITHUB_ARCHIVE_URI" --output "$TEMP_ARCHIVE_FILE"

# Unzip archive
echo 'Unzipping archive...';
unzip -q "$TEMP_ARCHIVE_FILE" -d "$TEMP_DIRECTORY";

# Install theme
echo 'Installing wallpapers...';
"$TEMP_BIN_DIRECTORY/win10-wallpapers.bash";
echo 'Installing lockscreens...';
"$TEMP_BIN_DIRECTORY/win10-lockscreens.bash";
echo 'Installing keyboard shortcuts...';
"$TEMP_BIN_DIRECTORY/win10-keyboard-shortcuts.bash";
echo 'Installing icon theme...';
"$TEMP_BIN_DIRECTORY/win10-icons.bash";

# Cleanup temporary files
echo 'Cleaning up temporary files...';
rm --recursive "$TEMP_DIRECTORY";

echo 'DONE!';
