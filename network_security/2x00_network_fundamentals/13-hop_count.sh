#!/bin/bash
traceroute -n "$1" 2>&1 | awk '/^\s*[0-9]/ {h=$1} END {print (h+0)}'
