#!/bin/bash
tshark -r "$1" -Y 'http.request.uri contains "UNION" or http.request.uri contains "SELECT" or http.request.uri contains "union" or http.request.uri contains "select"' -T fields -e http.request.uri

