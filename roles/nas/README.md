# nas

Cableado de backup del NAS.

## Qué hace

- Despliega `backup-script.service` a `/etc/systemd/system/` (con `[Install]`)
  y lo habilita/inicia. Handler de `daemon-reload`.
- Genera la regla udev `90-mount_media_backup.rules` desde plantilla
  (usa `nas_backup_disk_uuid`).
- Añade un cron diario que ejecuta `/media/data/scripts/clean_photos.sh`.

## Variables

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `nas_backup_disk_uuid` | `fd8ae7f1-...` | UUID del disco de backup para la regla udev. |

## Uso

```yaml
roles:
  - nas
```

Tags: `services`, `config`.
