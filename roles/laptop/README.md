# laptop

Escritorio y aplicaciones del portátil.

## Qué hace

- Añade PPAs: `libreoffice`, `nextcloud-devs/client`.
- Instala paquetes KDE y utilidades (`gparted`, `vlc`, `nextcloud-desktop`,
  `stacer`, `variety`, `pipx`, ...).
- Instala snaps: `gitkraken`, `joplin-desktop`, `breaktimer`, `auto-cpufreq`.
- Instala aplicaciones por archivo de tareas:
  - `brave.yml` — Brave (repositorio apt con keyring).
  - `enpass.yml` — Enpass (repositorio apt con keyring).
  - `typora.yml` — Typora (repositorio apt con keyring).
  - `httpi.yml` — HTTPie (AppImage en el home del usuario).
  - `chezmoi.yml` — Chezmoi (deb + `chezmoi init`).
  - `plasmoid.yml` — plasmoids de Plasma 6 (`kpackagetool6`), solo si
    `laptop_plasmoids` no está vacío.
- Herramientas de usuario (se ejecutan como `laptop_desktop_user`, no como root):
  - Starship (binario en `~/.local/bin`).
  - xxh (vía `pipx`) + plugins.
  - AppImageUpdate.

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `laptop_desktop_user` | `{{ lookup('env', 'USER') }}` | Usuario de escritorio para las tareas de scope de usuario. |
| `laptop_desktop_home` | home de `getent passwd` | Home del usuario de escritorio (no usar `ansible_env.HOME`: los facts son de root). |
| `laptop_starship_version` | `v1.23.0` | Versión de Starship. |
| `laptop_plasmoids` | `[]` | Lista de `{file, id}`; `file` en `files/plasmoids/`, `id` el plugin id. |

## Plasmoids

Las URLs de descarga de store.kde.org/pling llevan tokens que caducan, así que
los `.plasmoid` se descargan a mano (versión para Plasma 6), se guardan en
`roles/laptop/files/plasmoids/` y se declaran en `laptop_plasmoids`:

```yaml
laptop_plasmoids:
  - file: workrave-applet.plasmoid
    id: org.workrave.applet
```

Solo se instalan los que no aparecen en `kpackagetool6 -t Plasma/Applet -l`.

## Uso

```yaml
- hosts: 127.0.0.1
  connection: local
  become: true
  roles:
    - laptop
```

Tags: `repos`, `packages`, `config`.
