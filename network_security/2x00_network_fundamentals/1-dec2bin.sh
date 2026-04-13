#!/bin/bash
n=$1; result=""; for i in 7 6 5 4 3 2 1 0; do result+=$(( (n >> i) & 1 )); done; echo "$result"
