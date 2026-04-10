#!/bin/bash
awk -F: '$2~/^\$1\$/ {split($2,a,"$"); print $1}' "${1:-/etc/shadow}"
