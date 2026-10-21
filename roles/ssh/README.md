# ssh

Hardening SSH y notificación de login.

## Qué hace

- Desactiva el login de root en `/etc/ssh/sshd_config` (`PermitRootLogin no`).
  Handler de `Reload SSH`.
- Despliega `login-notify.sh` a `/etc/profile.d/` que envía un mensaje de
  Telegram en cada login (depende de `/media/data/scripts/telegram-notify`).

## Variables

No define variables.

## Uso

```yaml
roles:
  - ssh
```

## Tests

Tiene un escenario Molecule (`molecule/default/`) que verifica `PermitRootLogin no`
y la presencia de `login-notify.sh`.

Tags: `config`.
