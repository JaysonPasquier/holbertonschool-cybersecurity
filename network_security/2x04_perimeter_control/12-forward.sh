#!/bin/bash
sysctl -w net.ipv4.ip_forward=1 && { echo -e "\nnet.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf >/dev/null; }
