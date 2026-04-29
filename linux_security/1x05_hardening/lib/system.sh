#!/bin/bash

system_harden() {
    log "Starting system hardening..."

    # H-01: update package lists and upgrade installed packages non-interactively
    DEBIAN_FRONTEND=noninteractive apt-get update -y || { log "[ERROR] apt-get update failed"; return 1; }
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y || log "[WARN] apt-get upgrade had issues"
    log "System packages updated and upgraded"

    # H-02: remove insecure legacy network tools
    for pkg in telnet ftp netcat-traditional netcat-openbsd netcat; do
        if dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
            DEBIAN_FRONTEND=noninteractive apt-get purge -y "$pkg"
            log "Removed package: $pkg"
        fi
    done
    log "Bloatware removal complete"

    # H-03: install security monitoring tools if not already present
    for pkg in auditd fail2ban; do
        if ! dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
            DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" \
                || log "[WARN] Failed to install $pkg"
        fi
    done
    log "Security tools installed: auditd, fail2ban"
}
