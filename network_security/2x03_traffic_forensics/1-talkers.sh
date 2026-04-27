#!/bin/bash
tshark -r "$1" -T fields -e ip.src -q | sort | uniq -c | sort -rn | awk '{print $2}'

