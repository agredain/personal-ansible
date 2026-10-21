# main

Rol base compartido por todos los hosts (remotos y portátil).

## Qué hace

- Ejecuta `apt upgrade: dist` (es la **única copia** de esta tarea en el repo).
- Instala paquetes base: `bat`, `git`, `curl`, `fish`, `unzip`, `rar`, `neofetch`,
  `lm-sensors`, `microcode.ctl`, `rmlint`, `preload`, `ncdu`, `most`, `bleachbit`,
  `ubuntu-restricted-extras`, `exfat-fuse`, `exfat-utils`, `zip`, `unrar`.

## Variables

No define variables.

## Uso

```yaml
roles:
  - main
```

Tags: `upgrade`, `packages`.
