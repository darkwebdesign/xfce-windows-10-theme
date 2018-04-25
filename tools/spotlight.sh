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

function Spotlight()
{
    readonly __DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
    readonly __FILE__="${0##*/}";

    readonly SCRIPT_NAME='LightDM GTK+ Greeter Spotlight';
    readonly SCRIPT_VERSION='1.0';
    readonly SCRIPT_AUTHOR='Raymond Schouten';

    readonly SPOTLIGHT_PATH="$__DIR__/spotlight.jpg";
    readonly IMAGE_URI='https://dpcphotography.tumblr.com/random';
    readonly IMAGE_REGEX='https://[0-9]+.media.tumblr.com/[a-f0-9]+/tumblr_[a-zA-Z0-9_]+.jpg';
    declare -ri MIN_WIDTH=1280;
    declare -ri MIN_HEIGHT=800;
    declare -ri MAX_ATTEMPTS=10;

    function main()
    {
        checkDependencies;

        parseOptions "$@";

        showHelp;
    }

    function checkDependencies()
    {
        checkGetoptVersion;
        checkIdentify;
    }

    function checkGetoptVersion()
    {
        getopt --test &> /dev/null;
        if [[ $? -ne 4 ]]; then
            showError 'getopt(1) version 4 is required!';
        fi;
    }

    function checkIdentify()
    {
        if [[ ! -x "$(command -v 'identify')" ]]; then
            showError 'identify(1) is required!';
        fi;
    }

    function parseOptions()
    {
        eval set -- $(getopt --options 'h' --longoptions 'help,version,install,uninstall,status,rotate' --name "$__FILE__" -- "$@");

        while true; do
            case "$1" in
                -h|--help) showHelp; exit;;
                --version) showVersion; exit;;
                --install) installSpotlight; exit;;
                --uninstall) uninstallSpotlight; exit;;
                --status) spotlightStatus; exit;;
                --rotate) rotateBackground; exit;;
                --) shift; break;;
            esac;
            shift;
        done;
    }

    function installSpotlight()
    {
        requireRootPermissions;

        rotateBackground;

        if [[ $(checkCronjobInstalled) -eq 0 ]]; then
            installCronjob;
        fi;

        if [[ $(checkBackgroundConfigured) -eq 0 ]]; then
            installBackground;
        fi;
    }

    function installCronjob()
    {
        (crontab -l 2>/dev/null; echo "*/15 * * * * find '$SPOTLIGHT_PATH' -mtime +0 -exec '$__DIR__/$__FILE__' --rotate \; &>/dev/null; # $SCRIPT_NAME") | crontab -;
    }

    function installBackground()
    {
        uninstallBackground;
        echo "background = $SPOTLIGHT_PATH" >> /etc/lightdm/lightdm-gtk-greeter.conf;
    }

    function uninstallSpotlight()
    {
        requireRootPermissions;

        if [[ $(checkCronjobInstalled) -eq 1 ]]; then
            uninstallCronjob;
        fi;

        if [[ $(checkBackgroundConfigured) -eq 1 ]]; then
            uninstallBackground;
        fi;
    }

    function uninstallCronjob()
    {
        crontab -l 2>/dev/null | grep --invert-match "# $SCRIPT_NAME" | crontab -;
    }

    function uninstallBackground()
    {
        echo "$(cat /etc/lightdm/lightdm-gtk-greeter.conf | grep --extended-regexp --invert-match '^background\s*=')" > /etc/lightdm/lightdm-gtk-greeter.conf;
    }

    function spotlightStatus()
    {
        requireRootPermissions;

        if [[ $(checkCronjobInstalled) -eq 1 ]]; then
            echo "Spotlight cronjob is installed";
        else
            echo "Spotlight cronjob is not installed";
        fi;

        if [[ $(checkBackgroundConfigured) -eq 1 ]]; then
            echo "Spotlight background is configured";
        else
            echo "Spotlight background is not configured";
        fi;
    }

    function checkCronjobInstalled()
    {
        crontab -l 2>/dev/null | grep "# $SCRIPT_NAME" &>/dev/null;

        if [[ $? -eq 0 ]]; then
            echo 1;
        else
            echo 0;
        fi;
    }

    function checkBackgroundConfigured()
    {
        cat /etc/lightdm/lightdm-gtk-greeter.conf 2> /dev/null | grep --extended-regexp "^\s*background\s*=\s*$SPOTLIGHT_PATH\s*$" &> /dev/null;

        if [[ $? -eq 0 ]]; then
            echo 1;
        else
            echo 0;
        fi;
    }

    function requireRootPermissions()
    {
        if [[ "$UID" -ne 0 ]]; then
            showError 'this action requires root permissions!';
        fi;
    }

    function rotateBackground()
    {
        local -a images=();
        local -i attempt=1;

        while [[ $attempt -le $MAX_ATTEMPTS ]]; do

            images=($(wget --quiet --output-document - "$IMAGE_URI" | grep --only-matching --extended-regexp "$IMAGE_REGEX" | uniq ));

            for image in "${images[@]}"; do

                image="${image/https/http}";

                declare -a imageDimensions=($(identify "$image" | awk '{ match($0, /([0-9]+)x([0-9]+)/, a); print a[1], a[2]; }'));

                if [[ ${imageDimensions[0]} -lt $MIN_WIDTH ]] || [[ ${imageDimensions[1]} -lt $MIN_HEIGHT ]] || [[ ${imageDimensions[0]} -lt ${imageDimensions[1]} ]]; then
                    continue;
                fi;

                wget --quiet --output-document "$SPOTLIGHT_PATH" "$image";
                touch "$SPOTLIGHT_PATH";

                break 2;

            done;

            let attempt++;
        done;

        if [[ $attempt -gt $MAX_ATTEMPTS ]]; then
            showError 'failed to find pictures matching specifications';
        fi;
    }

    function showHelp()
    {
        echo;
        echo 'NAME';
        echo "  $SCRIPT_NAME - Display random pictures on the lock screen";
        echo;
        echo 'SYNOPSIS';
        echo "  $__FILE__ [options]";
        echo;
        echo 'DESCRIPTION';
        echo '  Spotlight is a feature that downloads pictures automatically from Tumblr and';
        echo '  displays them when the lock screen is being shown.';
        echo;
        echo '  A cronjob needs to be installed in order to download a new picture daily.';
        echo;
        echo 'OPTIONS';
        echo '  -h, --help             display this help and exit';
        echo '  --install              install cronjob and background';
        echo '  --uninstall            uninstall cronjob and background';
        echo '  --status               check cronjob and background status';
        echo '  --rotate               rotate background';
        echo '  --version              output version information and exit';
        echo;
    }

    function showVersion()
    {
        echo "$SCRIPT_NAME, version $SCRIPT_VERSION";
        echo 'Copyright (c) 2017 DarkWeb Design';
        echo;
        echo "Written by $SCRIPT_AUTHOR.";
    }

    function showError()
    {
        local message="$1";
        local -i exitCode="${2-1}";

        echo "$__FILE__: $message";
        exit $exitCode;
    }

    main "$@";
}

Spotlight "$@";
