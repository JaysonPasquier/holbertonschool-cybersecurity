#!/bin/bash
grep -m1 'dhcp-server-identifier' /var/lib/dhcp/dhclient*.leases 2>/dev/null | awk '{print $3; exit}' | tr -d ';\n'
