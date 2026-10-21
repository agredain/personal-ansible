# laptop

Escritorio y aplicaciones del portátil.

## Qué hace

- Añade PPAs: `atareao`, `y-ppa-manager`, `libreoffice`, `nextcloud-devs/client`,
  `appimagelauncher`.
- Instala paquetes KDE y utilidades (`latte-dock`, `gparted`, `vlc`, `nextcloud-client`,
  `stacer`, `variety`, ...).
- Instala snaps: `gitkraken`, `joplin-desktop`, `breaktimer`, `authy`, `auto-cpufreq`.
- Instala aplicaciones por archivo de tareas:
  - `brave.yml` — Brave (repositorio apt con keyring).
  - `enpass.yml` — Enpass (repositorio apt con keyring).
  - `typora.yml` — Typora (repositorio apt con keyring).
  - `ferdi.yml` — Ferdi (deb de GitHub).
  - `httpi.yml` — HTTPie (AppImage en el home del usuario).
  - `openlens.yml` — OpenLens (AppImage en el home del usuario).
  - `chezmoi.yml` — Chezmoi (deb + `chezmoi init`).
- Herramientas de usuario (se ejecutan como `laptop_desktop_user`, no como root):
  - Starship (binario en `~/.local/bin`).
  - xxh + plugins.
  - AppImageUpdate.

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `laptop_desktop_user` | `{{ ansible_user }}` | Usuario de escritorio para las tareas de scope de usuario. |

## Uso

```yaml
- hosts: 127.0.0.1
  connection: local
  become: true
  roles:
    - laptop
```

Tags: `repos`, `packages`, `config`.
