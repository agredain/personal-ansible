#!/usr/bin/env bash
# Bootstrap: instala Ansible en un venv local y los roles de requirements.yml.
set -euo pipefail

cd "$(dirname "$0")"

VENV_DIR=".venv"
PYTHON_BIN="${PYTHON_BIN:-python3}"

if [[ ! -d "${VENV_DIR}" ]]; then
  echo ">> Creando entorno virtual en ${VENV_DIR}"
  "${PYTHON_BIN}" -m venv "${VENV_DIR}"
fi

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

echo ">> Actualizando pip e instalando Ansible (requirements-dev.txt)"
pip install --upgrade pip
pip install -r requirements-dev.txt

echo ">> Instalando roles de requirements.yml"
# -p .ansible/roles: instala en el repo (gitignored), no en roles/ ni en ~/.ansible/roles
ansible-galaxy role install -p .ansible/roles -r requirements.yml

echo ">> Instalando colecciones de requirements.yml"
# -p .ansible/collections: instala en el repo (gitignored), no en ~/.ansible/collections
ansible-galaxy collection install -p .ansible/collections -r requirements.yml

echo ">> Listo. Activa el entorno con: source ${VENV_DIR}/bin/activate"
