#!/bin/bash

set -eu

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT

ostype() {
    uname | tr "[:upper:]" "[:lower:]"
}

os_detect() {
    export PLATFORM
    case "$(ostype)" in
        *'linux'*)  PLATFORM='linux'   ;;
        *'darwin'*) PLATFORM='osx'     ;;
        *'bsd'*)    PLATFORM='bsd'     ;;
        *)          PLATFORM='unknown' ;;
    esac
}

is_osx() {
    os_detect
    if [ "$PLATFORM" = "osx" ]; then
        return 0
    else
        return 1
    fi
}
alias is_mac=is_osx

is_exists() {
    which "$1" > /dev/null 2>&1
    return $?
}

if ! is_exists is_osx; then
    # "error: script is only supported with osx"
    exit 1
fi

if is_exitsts "brew"; then
    # "brew: already installed"
    exit 1
fi

if ! is_exists "ruby"; then
    # "error: require: ruby"
    exit 1
fi


/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if is_exists "brew"; then
    brew doctor
else
    # "error: brew: failed to install"
    exit 1
fi

# "brew: installed successfully"
