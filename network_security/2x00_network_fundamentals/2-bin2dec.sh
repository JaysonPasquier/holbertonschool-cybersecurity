#!/bin/bash
printf "%d\n" "$(echo "ibase=2; $1" | bc)"
