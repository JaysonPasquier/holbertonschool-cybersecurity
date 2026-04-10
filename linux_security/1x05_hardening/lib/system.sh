#!/bin/bash
system_harden() {
    
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
    grep -q '^PASS_MIN_LEN' /etc/login.defs || echo 'PASS_MIN_LEN   12' >> /etc/login.defs
    
    echo "deny = 5" > /etc/security/faillock.conf
    echo "fail_interval = 900" >> /etc/security/faillock.conf
    echo "unlock_time = 600" >> /etc/security/faillock.conf
    
    usermod -L root
    
    log "System hardening: password policy and lockout configured"
}
