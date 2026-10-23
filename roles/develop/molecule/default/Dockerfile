FROM ubuntu:24.04

# python3 is required by Ansible to run modules; python3-apt for the apt module.
# systemd + systemd-sysv are needed so the role's systemd handlers can run.
# cron for the cron module (crontab binary).
# The apt lists are kept: the role uses cache_valid_time, and an emptied lists
# directory would look freshly updated and skip the cache refresh.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-apt ca-certificates bash systemd systemd-sysv cron
