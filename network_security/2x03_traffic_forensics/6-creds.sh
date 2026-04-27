#!/bin/bash
tshark -r "$1" -T fields -e http.file_data | tr "&" "\n" | grep -E "^(password|pass|pwd)=" | cut -d"=" -f2

