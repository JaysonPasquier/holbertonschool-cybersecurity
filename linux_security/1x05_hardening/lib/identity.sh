#!/bin/bash

identity_harden() {
    log "Starting identity hardening..."

    # I-01: password age policy in login.defs
    grep -q '^PASS_MAX_DAYS' /etc/login.defs \
        && sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   $MAX_PASS_AGE/" /etc/login.defs \
        || echo "PASS_MAX_DAYS   $MAX_PASS_AGE" >> /etc/login.defs

    grep -q '^PASS_MIN_DAYS' /etc/login.defs \
        && sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs \
        || echo 'PASS_MIN_DAYS   1' >> /etc/login.defs

    # PAM complexity: uppercase + lowercase + digit + special char + minlen
    if ! grep -q 'pam_pwquality.so' /etc/pam.d/common-password 2>/dev/null; then
        echo "password requisite pam_pwquality.so retry=3 minlen=$MIN_PASS_LEN dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1" \
            >> /etc/pam.d/common-password
    fi
    log "Password policy: minlen=$MIN_PASS_LEN, complexity on, max_age=$MAX_PASS_AGE days"

    # I-02: lockout after N failed attempts via pam_faillock
    if ! grep -q "^deny = $LOCKOUT_ATTEMPTS" /etc/security/faillock.conf 2>/dev/null; then
        { echo "deny = $LOCKOUT_ATTEMPTS"; echo "fail_interval = 900"; echo "unlock_time = 600"; } \
            > /etc/security/faillock.conf
    fi
    log "Lockout: deny after $LOCKOUT_ATTEMPTS failed attempts"

    # I-03: remove UID > 1000 users not in sudo/wheel — check membership before deleting
    local removed_count=0
    while IFS=: read -r user _ uid _; do
        [[ "$uid" -le 1000 || "$user" == "nobody" ]] && continue
        if id "$user" 2>/dev/null | grep -qE "(sudo|wheel)"; then
            continue
        fi
        if userdel -r "$user" 2>/dev/null || userdel "$user" 2>/dev/null; then
            log "Removed unauthorized user: $user (UID=$uid)"
            ((removed_count++))
        else
            log "[WARN] Could not remove $user — manual review needed"
        fi
    done < /etc/passwd
    echo "$removed_count" > /tmp/users_removed
    log "User cleanup: $removed_count removed"

    # I-04: lock root password while keeping sudo functional
    passwd -l root || log "[WARN] Failed to lock root account"
    log "Root account locked"
}
