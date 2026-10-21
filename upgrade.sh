#!/usr/bin/env bash
# Ejecuta el playbook de upgrade contra el inventario.
# Uso: ./upgrade.sh [--check] [--diff] [--limit <patron>]
set -euo pipefail

cd "$(dirname "$0")"

export ANSIBLE_CONFIG="$(pwd)/ansible.cfg"
export ANSIBLE_VAULT_PASSWORD_FILE="${ANSIBLE_VAULT_PASSWORD_FILE:-${HOME}/.vault_pass}"

ansible-playbook -i inventories/ playbook-upgrade.yml "$@"

