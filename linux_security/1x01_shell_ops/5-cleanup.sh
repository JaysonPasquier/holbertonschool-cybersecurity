#!/bin/bash
while IFS= read -r user; do id "$user" >/dev/null 2>&1 && { usermod -L "$user" && echo "User $user locked"; } || echo "User $user not found"; done < "$1"
