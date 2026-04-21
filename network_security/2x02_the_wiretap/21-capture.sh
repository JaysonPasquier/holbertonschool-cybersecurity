#!/bin/bash
sudo tcpdump -i tun0 -c 50 -w capture.pcap
