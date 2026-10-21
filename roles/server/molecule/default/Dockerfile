FROM ubuntu:24.04

# python3 is required by Ansible to run modules; python3-apt for the apt module.
# ca-certificates + bash are needed for get_url (https) and module execution.
# systemd + systemd-sysv are needed so the role's systemd handlers can run.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-apt ca-certificates bash systemd systemd-sysv && \
    rm -rf /var/lib/apt/lists/*
