#!/bin/bash
tshark -r "$1" --export-objects http,/tmp/carved -q && md5sum /tmp/carved/* | awk '{print $1}'

