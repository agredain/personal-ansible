# server

Hardening de servidor headless.

## Qué hace

- Instala **Cockpit** (`cockpit`, `cockpit-networkmanager`, `cockpit-system`).
- Instala **BorgBackup**.
- Instala y configura **unattended-upgrades**:
  - Email de notificación (`server_unattended_email`).
  - `MailReport "on-change"`.
  - Limpieza de kernels y dependencias no usados.
  - `/etc/apt/apt.conf.d/20auto-upgrades` con `APT::Periodic` (activa las
    actualizaciones automáticas; equivale a `dpkg-reconfigure -plow unattended-upgrades`).
- Handler: reinicia `cockpit.socket` al instalar Cockpit.

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
