FROM ubuntu:24.04

# python3 is required by Ansible to run modules; python3-apt for the apt module.
# systemd + systemd-sysv are needed so the role's systemd handlers can run.
# udev for the udevadm handler; cron for the cron module (crontab binary).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-apt ca-certificates bash systemd systemd-sysv udev cron && \
    rm -rf /var/lib/apt/lists/*
