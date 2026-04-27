#!/bin/bash
tshark -r "$1" -Y "ip.src == $(tshark -r "$1" -T fields -e ip.src | sort | uniq -c | sort -rn | awk 'NR==1{print $2}')" -T fields -e frame.time | awk 'NR==1; END{print}'

