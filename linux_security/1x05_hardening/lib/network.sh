#!/bin/bash

network_harden() {
    log "Starting network hardening..."

    # N-01: default deny incoming, allow outgoing
    ufw default deny incoming
    ufw default allow outgoing

    # N-02: open only configured ports — values from harden.cfg, not literals
    ufw allow "$SSH_PORT/tcp"
    ufw allow "$HTTP_PORT/tcp"
    ufw allow "$HTTPS_PORT/tcp"

    if ! ufw status | grep -q "Status: active"; then
        ufw --force enable || { log "[ERROR] Failed to enable UFW"; return 1; }
    fi
    log "UFW enabled: ports $SSH_PORT $HTTP_PORT $HTTPS_PORT open"

    # N-03: disable IP forwarding and ICMP echo — persisted and applied immediately
    local SYSCTL_FILE="/etc/sysctl.d/99-hardening.conf"

    grep -q '^net.ipv4.ip_forward' "$SYSCTL_FILE" 2>/dev/null || \
        echo 'net.ipv4.ip_forward=0' >> "$SYSCTL_FILE"

    grep -q '^net.ipv4.icmp_echo_ignore_all' "$SYSCTL_FILE" 2>/dev/null || \
        echo 'net.ipv4.icmp_echo_ignore_all=1' >> "$SYSCTL_FILE"

    sysctl -p "$SYSCTL_FILE" || log "[WARN] sysctl had issues applying $SYSCTL_FILE"
    log "Kernel params set: ip_forward=0, icmp_echo_ignore_all=1"
}
