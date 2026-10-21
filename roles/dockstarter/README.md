# dockstarter

Instalador de DockStarter.

## Qué hace

- Ejecuta el instalador oficial `curl -fsSL https://get.dockstarter.com | bash`.
  Usa `creates: /usr/local/bin/ds` para ser idempotente (no se re-ejecuta si
  DockStarter ya está instalado).

## Variables

No define variables.

## Uso

```yaml
roles:
  - dockstarter
```

Tags: `packages`.
