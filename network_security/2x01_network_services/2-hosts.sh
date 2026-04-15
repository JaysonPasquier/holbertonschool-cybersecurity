#!/bin/bash
awk '/(^|[[:space:]])localhost($|[[:space:]])/ {printf "%s", $1; exit}' /etc/hosts
