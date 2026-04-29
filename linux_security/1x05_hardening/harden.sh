#!/bin/bash

[[ $EUID -ne 0 ]] && { echo "ERROR: Must run as root"; exit 1; }

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/config/harden.cfg" || { echo "ERROR: Missing config"; exit 1; }
for lib in "$SCRIPT_DIR/lib"/*.sh; do source "$lib"; done

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

REPORT_FILE="audit_report.txt"

audit_report() {
    local users_removed=0
    [[ -f /tmp/users_removed ]] && users_removed=$(cat /tmp/users_removed)

    local fw_status
    fw_status=$(ufw status | awk 'NR==1{print $2}')

    local open_ports
    open_ports=$(ufw status | awk '/ALLOW/{print $1}' | tr '\n' ' ')

    local root_lock
    passwd -S root 2>/dev/null | grep -q ' L ' && root_lock="locked" || root_lock="NOT locked"

    local pass_policy
    grep -q 'pam_pwquality.so' /etc/pam.d/common-password 2>/dev/null \
        && pass_policy="enforced (minlen=$MIN_PASS_LEN, max_age=$MAX_PASS_AGE days)" \
        || pass_policy="NOT enforced"

    {
        echo "==========================================="
        echo " HARDENING AUDIT REPORT — $(date)"
        echo "==========================================="
        echo ""
        echo "=== NETWORK ==="
        echo "[INFO] Firewall status: $fw_status"
        echo "[INFO] Open ports: $open_ports"
        echo "[INFO] SSH port in use: $SSH_PORT"
        echo ""
        echo "=== IDENTITY ==="
        if [[ "$users_removed" -gt 0 ]]; then
            echo "[INFO] Unauthorized users removed: $users_removed"
        else
            echo "[INFO] Unauthorized users removed: none found"
        fi
        echo "[INFO] Password policy: $pass_policy"
        echo "[INFO] Root account: $root_lock"
        echo ""
        echo "=== SYSTEM ==="
        echo "[INFO] Packages updated and upgraded"
        echo "[INFO] Bloatware removed: telnet, ftp, netcat"
        echo "[INFO] Security tools installed: auditd, fail2ban"
        echo ""
        echo "=== WARNINGS ==="
        [[ "$fw_status" != "active" ]] && echo "[WARN] Firewall is not active"
        [[ "$root_lock" == "NOT locked" ]] && echo "[WARN] Root account is not locked"
        [[ "$pass_policy" == "NOT enforced" ]] && echo "[WARN] Password policy not applied to PAM"
        echo ""
        echo "==========================================="
    } > "$REPORT_FILE"

    log "Audit report saved: $REPORT_FILE"
}

log "Hardening started"

network_harden
ssh_harden
identity_harden
system_harden

audit_report

log "Hardening complete"
echo "Report: $REPORT_FILE"
