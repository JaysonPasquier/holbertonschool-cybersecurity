#!/bin/bash
apt-get update -y && apt-get install -y nftables wireguard wireguard-tools && systemctl enable nftables
