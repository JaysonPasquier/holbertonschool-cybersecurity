#!/bin/bash
tshark -r "$1" -T fields -e urlencoded-form.value | tr "&" "\n" | grep -E "^(password|pass|pwd)=" | cut -d"=" -f2

