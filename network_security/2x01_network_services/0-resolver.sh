#!/bin/bash
grep -m1 '^nameserver ' /etc/resolv.conf | awk '{print $2}' || resolvectl status | awk '/Current DNS Server:/{print $4; exit}'
