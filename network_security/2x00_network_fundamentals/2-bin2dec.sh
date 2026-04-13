#!/bin/bash
result=0; for i in 7 6 5 4 3 2 1 0; do result=$(( result + (${1:7-i:1} << i) )); done; echo "$result"
