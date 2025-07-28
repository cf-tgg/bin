#!/bin/sh
# -*- mode: sh; -*- vim: ft=sh:ts=2:sw=2:norl:et:
# Time-stamp: <2025-07-24 18:07:54 cf>
# Box: [Linux 6.15.6-zen1-1-zen x86_64 GNU/Linux]


[ "$(id -u)" -eq 0 ] || {
    echo "Error: This script must be run as root." >&2
    exit 1
}

ini_files="$(find /etc -type f -name 'php.ini' 2>/dev/null)"

if [ -z "$ini_files" ]; then
    echo "No php.ini files found under /etc"
    exit 0
fi

for ini in $ini_files; do
    echo "Checking: $ini"

    changed=0

    if grep -Eq '^expose_php\s*=' "$ini"; then
        echo "  -> Setting expose_php = Off"
        sed -i 's/^expose_php\s*=.*/expose_php = Off/' "$ini"
    else
        echo "  -> Adding expose_php = Off"
        printf '\nexpose_php = Off\n' >> "$ini"
    fi

    if grep -Eq '^allow_url_fopen\s*=' "$ini"; then
        echo "  -> Setting allow_url_fopen = Off"
        sed -i 's/^allow_url_fopen\s*=.*/allow_url_fopen = Off/' "$ini"
    else
        echo "  -> Adding allow_url_fopen = Off"
        printf '\nallow_url_fopen = Off\n' >> "$ini"
    fi

done

exit 0
