#!/bin/bash
awk -F: '$3 >= 1000 {print $1}' "${1:-/etc/passwd}" | while read user; do id -nG "$user" 2>/dev/null | tr ' ' '\n' | grep -E '^(disk|docker|shadow)$' | while read g; do echo "$user:$g"; done; done
