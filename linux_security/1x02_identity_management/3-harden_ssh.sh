#!/bin/bash
conf="${1:-/etc/ssh/sshd_config}"; sed -i 's/^\s*PermitRootLogin.*/PermitRootLogin no/;s/^\s*PasswordAuthentication.*/PasswordAuthentication no/;s/^\s*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$conf" && sshd -t -f "$conf" && (systemctl reload ssh || systemctl reload sshd 2>/dev/null || true)
