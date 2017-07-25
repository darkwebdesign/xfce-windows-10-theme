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

function Cur2X11()
{
    readonly __DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
    readonly __FILE__="${0##*/}";

    readonly SCRIPT_NAME='Cur2x11';
    readonly SCRIPT_VERSION='1.0';
    readonly SCRIPT_AUTHOR='Raymond Schouten';

    declare -a args;
    declare input;
    declare output;
    declare -a attributes;

    function main()
    {
        checkDependencies;

        parseOptions "$@";
        parseArguments;
        validateInput;

        extractAttributes;
        extractImages;
        generateConfig;
        generateX11Cursor;

        echo "X11 cursor '$output' generated!";
    }

    function checkDependencies()
    {
        checkGetoptVersion;
        checkIcotool;
        checkXcursorgen;
    }

    function checkGetoptVersion()
    {
        getopt --test &> /dev/null;
        if [[ $? -ne 4 ]]; then
            showError 'getopt(1) version 4 is required!';
        fi;
    }

    function checkIcotool()
    {
        if [[ ! -x "$(command -v 'icotool')" ]]; then
            showError 'icotool(1) is required!';
        fi;
    }

    function checkXcursorgen()
    {
        if [[ ! -x "$(command -v 'xcursorgen')" ]]; then
            showError 'xcursorgen(1) is required!';
        fi;
    }

    function parseOptions()
    {
        eval set -- $(getopt --options 'h' --longoptions 'help,version' --name "$__FILE__" -- "$@");

        while true; do
            case "$1" in
                -h|--help) showHelp; exit;;
                --version) showVersion; exit;;
                --) shift; break;;
            esac;
            shift;
        done;

        args=("$@");
    }

    function parseArguments()
    {
        input="${args[0]}";
        output="${args[1]}";
    }

    function validateInput()
    {
        if [[ -z "$input" ]]; then
            showMissingArgument;
        fi;

        if [[ ! -f "$input" ]]; then
            showError 'input file not found!';
        fi;

        if [[ -z "$output" ]]; then
            output="$input";
            output="${output##*/}";
            output="${output%.*}";
        fi
    }

    function extractAttributes()
    {
        local -i index;
        local -i width;
        local -i height;
        local -i bitDepth;
        local -i hotspotX;
        local -i hotspotY;

        while IFS= read -r line; do
            index=$(echo "${line}" | cut -d' ' -f2 | cut -d'=' -f2);
            width=$(echo "${line}" | cut -d' ' -f3 | cut -d'=' -f2);
            height=$(echo "${line}" | cut -d' ' -f4 | cut -d'=' -f2);
            bitDepth=$(echo "${line}" | cut -d' ' -f5 | cut -d'=' -f2);
            hotspotX=$(echo "${line}" | cut -d' ' -f7 | cut -d'=' -f2);
            hotspotY=$(echo "${line}" | cut -d' ' -f8 | cut -d'=' -f2);

            if [[ $width -ne $height ]]; then
                showError "invalid dimensions for image at index #$index!";
            fi;

            attributes+=("[index]=$index [width]=$width [height]=$height [bitDepth]=$bitDepth [hotspotX]=$hotspotX [hotspotY]=$hotspotY");
        done < <(icotool --list "$input");
    }

    function extractImages()
    {
        local output;

        output=$(icotool --extract "$input");

        if [[ -n "$output" ]]; then
            showError "failed to extract .png-files from '$input'!";
        fi;
    }

    function generateConfig()
    {
        local inputBasename;

        inputBasename="${input%.*}";

        echo "# <size> <xhot> <yhot> <filename> <ms-delay>" > "$output.conf";
        for attribute in "${attributes[@]}"; do
            local -A attribute="($attribute)";
            echo "${attribute['width']} ${attribute['hotspotX']} ${attribute['hotspotY']} ${inputBasename}_${attribute['index']}_${attribute['width']}x${attribute['height']}x${attribute['bitDepth']}.png 0" >> "$output.conf";
        done;
    }

    function generateX11Cursor()
    {
        xcursorgen "$output.conf" "$output";

        if [[ $? -gt 0 ]]; then
            showError "failed to generate X11 cursor '$output'!";
        fi;
    }

    function showHelp()
    {
        echo;
        echo 'NAME';
        echo "  $SCRIPT_NAME - Generate Xubuntu x11 cursor from Windows 10 cursor";
        echo;
        echo 'SYNOPSIS';
        echo "  $__FILE__ [options] <input> [<output>]";
        echo;
        echo 'DESCRIPTION';
        echo '  ...';
        echo;
        echo 'OPTIONS';
        echo '  -v, --verbose          increase verbosity';
        echo '  -h, --help             display this help and exit';
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

    function showMissingArgument()
    {
        echo "$__FILE__: missing argument";
        echo "Try '$__FILE__ --help' for more information.";
        exit 1;
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

Cur2X11 "$@";
