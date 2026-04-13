#!/bin/bash
echo "$1" | awk '{c=$1;for(i=1;i<=4;i++){o=0;for(j=7;j>=0;j--){if(c>0){o+=2^j;c--}};printf o (i<4?".":"\n")}}'
