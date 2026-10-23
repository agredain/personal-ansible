# develop

Herramientas de desarrollo.

## Qué hace

- Instala `zeal`, `cppcheck` y `docker.io`.
- Añade `develop_docker_user` al grupo `docker`.
- Añade un cron semanal que ejecuta `docker image prune -f`
  (vía módulo `cron`, no `/etc/cron.weekly/`).

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `develop_docker_user` | `{{ lookup('env', 'USER') }}` | Usuario que se añade al grupo `docker`. |

## Uso

```yaml
roles:
  - develop
```

## Tests

Escenario Molecule (`molecule/default/`) que verifica paquetes y grupo `docker`.

Tags: `packages`, `config`.
