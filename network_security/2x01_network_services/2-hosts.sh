#!/bin/bash
awk '/(^|[[:space:]])localhost($|[[:space:]])/ {print $1; exit}' /etc/hosts
