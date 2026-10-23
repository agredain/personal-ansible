# main

Rol base compartido por todos los hosts (remotos y portátil).

## Qué hace

- Ejecuta `apt upgrade: dist` (es la **única copia** de esta tarea en el repo).
- Acepta la EULA de `ttf-mscorefonts-installer` vía debconf (instalación no interactiva).
- Instala paquetes base: `bat`, `git`, `curl`, `fish`, `unzip`, `rar`,
  `lm-sensors`, `rmlint`, `preload`, `ncdu`, `most`, `bleachbit`,
  `ubuntu-restricted-extras`, `exfat-fuse`, `exfatprogs`, `zip`, `unrar`.
  Handler: `fc-cache -f` para registrar las fuentes nuevas.
- Instala `intel-microcode` o `amd64-microcode` según la CPU (nada en ARM).

## Variables

No define variables.

## Uso

```yaml
roles:
  - main
```

Tags: `upgrade`, `packages`.
