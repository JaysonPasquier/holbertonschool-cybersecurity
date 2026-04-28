#!/bin/bash
nft flush ruleset && nft add table inet filter && nft add chain inet filter input '{ type filter hook input priority 0; policy accept; }' && nft add chain inet filter forward '{ type filter hook forward priority 0; policy accept; }' && nft add chain inet filter output '{ type filter hook output priority 0; policy accept; }' && (sleep 300 && bash /root/2-panic.sh) &
