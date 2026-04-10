#!/bin/bash
[ -d "$1" ] || exit 1; mkdir -p "$1/backups"; for log in "$1"/*.log; do [ -f "$log" ] || continue; [ $(stat -c%s "$log") -gt 1024 ] && { gzip "$log" && mv "$log.gz" "$1/backups/" || :; } || echo "Skipping small file: $(basename "$log")"; done
