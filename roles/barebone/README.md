# barebone

Kodi (media center): PPA y paquetes.

## Qué hace

- Añade el PPA `team-xbmc/ppa` (repositorio oficial de Kodi) con
  `update_cache: true`.
- Instala `x264` y `x265` (códecs de vídeo).
- Instala los paquetes de Kodi con **lista explícita** (sin wildcards, que el
  módulo `apt` no expande): `kodi`, `kodi-inputstream-adaptive`,
  `kodi-inputstream-rtmp`, `kodi-peripheral-joystick`, `kodi-vfs-libarchive`.

El `apt upgrade: dist` **no** se ejecuta aquí: lo hace el rol `main`, único
lugar donde se actualiza la distribución.

## Variables

No define variables.

## Uso

```yaml
roles:
  - barebone
```

## Tests

`tests/test.yml` aplica el rol contra `localhost` con `become: true`.

Tags: `packages`.
