#!/bin/bash
dig +trace "$1" 2>&1 | grep "Received .* bytes from" | grep -v "10.0.2." | sed -E 's/.*Received [0-9]+ bytes from ([0-9.]+)#.*/\1/' | head -1
