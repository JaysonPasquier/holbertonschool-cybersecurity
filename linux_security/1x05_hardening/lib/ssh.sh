#!/bin/bash
ssh_harden() {
    local cfg="/etc/ssh/sshd_config"
    
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$cfg"
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$cfg"
    sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$cfg"
    
    log "SSH hardening: S-01 S-02 complete (keys-only, no root)"
}
