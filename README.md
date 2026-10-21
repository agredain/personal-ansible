# personal-ansible

Playbooks y roles Ansible para provisionar y mantener mi homelab: un NAS, un VPS
en Oracle Cloud y mi portátil.

## Estructura

```
.
├── ansible.cfg              # Configuración de Ansible (inventario, roles_path, vault)
├── install.sh               # Bootstrap: venv + Ansible + roles de requirements.yml
├── upgrade.sh               # Ejecuta playbook-upgrade.yml (con --check/--diff/--limit)
├── requirements.yml         # Roles y colecciones de Galaxy (versiones fijadas)
├── playbook.yml             # Provisioning de hosts remotos (main + server)
├── laptop.yml               # Provisioning local del portátil (main + laptop + claude + VS Code)
├── playbook-upgrade.yml     # Upgrade de paquetes + DockStarter
├── group_vars/
│   └── all.yml              # Variables comunes (p. ej. extensiones de VS Code)
├── inventories/
│   ├── inventory.yml        # Hosts (sin secretos)
│   └── vault.yml            # Secretos CIFRADOS (ansible_ssh_pass, ansible_become_pass)
├── roles/
│   ├── barebone/            # Base para Kodi/media box
│   ├── claude/              # Claude Desktop (Anthropic)
│   ├── develop/             # Herramientas de desarrollo (Zeal, CppCheck, Docker)
│   ├── dockstarter/         # Instalador de DockStarter
│   ├── laptop/              # Escritorio y aplicaciones del portátil
│   ├── main/                # Paquetes base compartidos (incluye `apt upgrade: dist`)
│   ├── nas/                 # Backup del NAS (systemd + udev + cron)
│   ├── server/              # Servidor headless (Cockpit, BorgBackup, unattended-upgrades)
│   └── ssh/                 # Hardening SSH + notificación de login por Telegram
└── .github/workflows/ci.yml # CI: ansible-lint + syntax check + molecule
```

## Requisitos

- Ansible (se instala en un venv local con `install.sh`)
- Podman (para Molecule, solo en desarrollo/CI)
- Python 3.10+

## Instalación

```bash
./install.sh
source .venv/bin/activate
```

`install.sh` crea un entorno virtual en `.venv/`, instala Ansible y los roles y
colecciones de `requirements.yml`.

## Inventario y secretos

El inventario vive en `inventories/` y se compone de dos archivos que Ansible
fusiona automáticamente (ver `inventory` en `ansible.cfg`):

- `inventory.yml` — hosts y variables **sin secretos** (se commitea).
- `vault.yml` — contraseñas **cifradas** con Ansible Vault (se commitea cifrado).

La clave vault se guarda en `~/.vault_pass` (gitignored). Para editar los
secretos:

```bash
ansible-vault edit inventories/vault.yml
```

> **Nota:** el directorio de trabajo debe tener permisos `755` (no world-writable),
> de lo contrario Ansible ignora `ansible.cfg`.

## Uso

### Provisionar hosts remotos (NAS, VPS)

```bash
ansible-playbook playbook.yml
```

Aplica los roles `main` y `server` a todos los hosts del inventario.

### Provisionar el portátil

```bash
ansible-playbook laptop.yml
```

Se ejecuta contra `127.0.0.1` con `connection: local`. Aplica `main`, `laptop`,
`claude` y el rol de VS Code (extensiones definidas en `group_vars/all.yml`).

### Upgrade de paquetes

```bash
./upgrade.sh              # aplica el upgrade
./upgrade.sh --check      # dry-run
./upgrade.sh --diff       # muestra los cambios
./upgrade.sh --limit agrenas.local   # solo un host
```

Actualiza todos los paquetes (`apt upgrade: dist`) y, si el host tiene
`dockstarted: true`, ejecuta `ds -y -u` (DockStarter).

## Roles

| Rol | Propósito | Variables principales |
|-----|-----------|----------------------|
| `main` | Paquetes base + `apt upgrade: dist` (única copia) | — |
| `server` | Cockpit, BorgBackup, unattended-upgrades | `server_unattended_email` |
| `laptop` | Escritorio KDE, PPAs, snaps, apps (Brave, Enpass, Typora, Ferdi, Httpi, OpenLens, Chezmoi) | `laptop_desktop_user` |
| `claude` | Claude Desktop + cowork KVM opcional | `claude_cowork` |
| `nas` | Servicio de backup, regla udev, cron de fotos | `nas_backup_disk_uuid` |
| `ssh` | Desactiva login root + notificación Telegram | — |
| `develop` | Zeal, CppCheck, Docker + prune semanal | — |
| `barebone` | Kodi + PPA team-xbmc | — |
| `dockstarter` | Instalador de DockStarter | — |

Cada rol tiene su propio `README.md` con más detalle.

## Desarrollo

### Lint

```bash
ansible-lint
```

La configuración está en `.ansible-lint` (profile `moderate`).

### Molecule

Los roles `claude`, `main`, `ssh` y `server` tienen escenarios Molecule
(`roles/<rol>/molecule/default/`) que convergen y verifican en un contenedor
Ubuntu 24.04 con Podman:

```bash
cd roles/claude
BUILDAH_ISOLATION=chroot molecule test
```

### CI

El workflow `.github/workflows/ci.yml` ejecuta en cada push/PR:

1. **lint** — `ansible-lint` + `ansible-playbook --syntax-check` de los 3 playbooks.
2. **molecule** — `molecule test` para `claude`, `main`, `ssh` y `server` (matriz).

## Licencia

[MIT](LICENSE.md) — Copyright (c) 2020 agredain
