# Linux Server Hardening Framework

A modular Bash framework that automates common security hardening tasks on Debian/Ubuntu servers: firewall configuration, SSH lockdown, password policy enforcement, user cleanup, package hygiene, and audit reporting.

---

## File Structure

```
1x05_hardening/
├── harden.sh           # Entry point — orchestrates all hardening steps
├── config/
│   └── harden.cfg      # All tunable values (ports, thresholds, paths)
└── lib/
    ├── network.sh      # UFW firewall rules and sysctl kernel params
    ├── ssh.sh          # sshd_config hardening (port, auth, root login)
    ├── identity.sh     # Password policy, account lockout, user cleanup, root lock
    └── system.sh       # Package updates, bloatware removal, security tools
```

No hardcoded values exist in `harden.sh` or `lib/*.sh` — everything is read from `config/harden.cfg`.

---

## Usage

1. Edit `config/harden.cfg` to match your environment (SSH port, allowed IPs, etc.).
2. Run the script as root:

```bash
sudo bash harden.sh
```

3. Review the generated `audit_report.txt` for a summary of actions taken and any warnings.
4. Check `/var/log/hardening.log` for a timestamped log of every action.
