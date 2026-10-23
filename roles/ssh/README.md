# ssh

Hardening SSH y notificación de login.

## Qué hace

- Desactiva el login de root en `/etc/ssh/sshd_config` (`PermitRootLogin no`).
  Handler de `Reload SSH`.
- Valida `sshd_config` con `sshd -t` antes de escribirlo.
- Si `ssh_login_notify: true`, despliega `login-notify.sh` (plantilla) a
  `/etc/profile.d/`, que envía un mensaje de Telegram en cada login SSH. Si el
  notificador no existe, el script no hace nada. Con `false` lo elimina.

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `ssh_login_notify` | `false` | Despliega la notificación de login (en el inventario: `true` en el NAS). |
| `ssh_telegram_notify_bin` | `/media/data/scripts/telegram-notify` | Script que envía el mensaje de Telegram. |

## Uso

```yaml
roles:
  - ssh
```

## Tests

Tiene un escenario Molecule (`molecule/default/`) que verifica `PermitRootLogin no`
y la presencia de `login-notify.sh`.

Tags: `config`.
