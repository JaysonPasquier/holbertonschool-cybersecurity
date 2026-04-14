#!/bin/bash
ip -4 route show default | awk '/default/ {print $3; exit}'
