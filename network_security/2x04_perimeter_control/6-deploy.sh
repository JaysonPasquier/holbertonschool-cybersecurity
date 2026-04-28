#!/bin/bash
scp skeleton.conf engineer@$1:~/skeleton.conf && ssh engineer@$1 "sudo bash ~/2-panic.sh && sudo nft -f ~/skeleton.conf && sudo nft list ruleset"
