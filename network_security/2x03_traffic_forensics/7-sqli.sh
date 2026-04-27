#!/bin/bash
tshark -r "$1" -T fields -e http.request.uri | grep -iE "(union|select|%20union|%20select|union%20|select%20)"

