#!/bin/bash
user="$1"; sudoers="/etc/sudoers.d/junior"; useradd -m -s /bin/bash "$user" 2>/dev/null || true; echo -e "# Junior Operator: restart apache2 and read logs only\n$user ALL=(ALL) /usr/bin/systemctl restart apache2\n$user ALL=(ALL) /usr/bin/journalctl" > "$sudoers"; chmod 440 "$sudoers"; chown root:root "$sudoers"; visudo -c -f "$sudoers"
