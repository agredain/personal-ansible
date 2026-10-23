# nas

Cableado de backup del NAS.

## Qué hace

- Despliega `backup-script.service` (oneshot, sin `[Install]`) a
  `/etc/systemd/system/`. Handler de `daemon-reload`. No se habilita ni se
  arranca: lo lanza la regla udev al conectar el disco de backup.
- Genera la regla udev `90-mount_media_backup.rules` desde plantilla
  (usa `nas_backup_disk_uuid`). Handler de `udevadm control --reload-rules`.
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

## Tests

Escenario Molecule (`molecule/default/`) que verifica la unidad, la regla udev
y el cron.

Tags: `services`, `config`.
