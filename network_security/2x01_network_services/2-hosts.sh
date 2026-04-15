#!/bin/bash
awk '/(^| )localhost($| )/ { for(i=1; i<=NF; i++) if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/){ print $i; exit } }' /etc/hosts
