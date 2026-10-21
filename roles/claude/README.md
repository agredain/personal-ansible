# claude

Instala Claude Desktop desde el repositorio apt oficial de Anthropic.

## Qué hace

- Descarga la clave de firma a `/usr/share/keyrings/claude-desktop-archive-keyring.asc`.
- Añade el repositorio apt con `signed-by=`.
- Instala `claude-desktop`.
- Opcional (`claude_cowork: true`): crea el grupo `kvm`, añade al usuario y
  carga `vhost_vsock` al arrancar.

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `claude_cowork` | `false` | Activa la configuración KVM para cowork. |

## Uso

```yaml
roles:
  - claude
```

## Tests

Tiene un escenario Molecule completo (`molecule/default/`) con `verify.yml` que
comprueba paquete, repositorio, keyring, grupo kvm y vsock.

Tags: `packages`, `repos`, `config`.
