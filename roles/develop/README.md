# develop

Herramientas de desarrollo.

## Qué hace

- Instala `zeal`, `cppcheck` y `docker.io`.
- Añade un cron semanal que ejecuta `docker image prune -f`
  (vía módulo `cron`, no `/etc/cron.weekly/`).

## Variables

No define variables.

## Uso

```yaml
roles:
  - develop
```

Tags: `packages`, `config`.
