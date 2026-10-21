# server

Hardening de servidor headless.

## Qué hace

- Instala **Cockpit** (`cockpit`, `cockpit-networkmanager`, `cockpit-systemd`).
- Instala **BorgBackup**.
- Instala y configura **unattended-upgrades**:
  - Email de notificación (`server_unattended_email`).
  - `MailReport "on-change"`.
  - Limpieza de kernels y dependencias no usados.
  - `APT::Periodic` en `/etc/apt/apt.conf.d/20auto-upgrades`.
  - `dpkg-reconfigure -plow unattended-upgrades -f noninteractive`.
- Handlers: reinicia `cockpit` y `unattended-upgrades` al cambiar la config.

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `server_unattended_email` | `agredain@gmail.com` | Email para notificaciones de unattended-upgrades. |

## Uso

```yaml
roles:
  - server
```

Tags: `packages`, `config`.
