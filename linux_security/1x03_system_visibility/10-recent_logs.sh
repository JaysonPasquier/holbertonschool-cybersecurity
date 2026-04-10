#!/bin/bash
from_d=$(date -d '30 minutes ago' '+%b %e %H:%M:%S')
awk -v from="$from_d" '
    index($0, "sshd") &&
    $1" "$2" "$3 >= from
' "$1"
