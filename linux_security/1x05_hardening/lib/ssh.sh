#!/bin/bash

ssh_harden() {
    local cfg="/etc/ssh/sshd_config"

    # Replace directive if present (commented or not), otherwise append
    _sshd_set() {
        local key="$1" value="$2"
        if grep -qE "^#*\s*${key}\b" "$cfg"; then
            sed -i "s|^#*\s*${key}.*|${key} ${value}|" "$cfg"
        else
            echo "${key} ${value}" >> "$cfg"
        fi
    }

    _sshd_set "Port" "$SSH_PORT"
    _sshd_set "PermitRootLogin" "no"
    _sshd_set "PasswordAuthentication" "no"
    _sshd_set "PubkeyAuthentication" "yes"

    log "SSH hardened: port=$SSH_PORT, root=no, password=no, pubkey=yes"
}
