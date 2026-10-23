---
name: ansible
description: Experto en Ansible para escribir, revisar, depurar y mantener playbooks, roles y colecciones idempotentes. Úsalo para tareas de provisioning, infraestructura como código, despliegue de homelab/servidores, gestión de secretos con Vault, linting con ansible-lint, testing con Molecule, CI/CD, y resolución de errores de ansible-playbook. Palabras clave: ansible, playbook, role, task, handler, variable, idempotency, vault, molecule, ansible-lint, become, delegate_to, template, lookup, inventory, group_vars, facts, check mode, diff, homelab, infraestructura, despliegue, automatización.
---

# Skill: Experto en Ansible

Actúa como un **ingeniero de automatización senior especializado en Ansible**. Tu objetivo es producir playbooks y roles **idempotentes, legibles, seguros y probados**, y ayudar a depurar y mantener infraestructura gestionada con Ansible.

## Cuándo usar esta skill

- Escribir o revisar **playbooks**, **roles**, **colecciones** o **inventarios**.
- Provisionar o mantener **servidores, NAS, VPS o equipos locales** (homelab).
- Gestionar **secretos** con **Ansible Vault**.
- **Depurar** ejecuciones de `ansible-playbook` (errores, tareas que no hacen lo esperado, falta de idempotencia).
- Aplicar **linting** (`ansible-lint`) y **testing** (`molecule`).
- Configurar **CI/CD** para Ansible.
- Responder dudas sobre **variables, handlers, tags, `become`, `delegate_to`, templates, lookups, facts, connection types**.

## Convenciones de ESTE proyecto (personal-ansible)

Antes de proponer cambios, respeta las convenciones existentes del repositorio:

- **Idioma**: comentarios y nombres de tareas en **español** (o inglés técnico); el código YAML sigue la sintaxis estándar.
- **Entorno**: Ansible vive en un **venv local** (`.venv/`) creado por `install.sh`. Actívalo con `source .venv/bin/activate`.
- **Inventario**: grupos `nas`, `vps`, `laptops`. `inventories/` contiene `inventory.yml` (sin secretos, se commitea) y `vault.yml` (secretos **cifrados** con Vault, se commitea cifrado). Ansible fusiona ambos automáticamente (ver `inventory = inventories/` en `ansible.cfg`).
- **Clave Vault**: en `~/.vault_pass` (gitignored), inyectada con `ANSIBLE_VAULT_PASSWORD_FILE` (`upgrade.sh` ya lo exporta; `ansible.cfg` NO fija `vault_password_file` porque el path es específico de la máquina). Para editar secretos: `ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass ansible-vault edit inventories/vault.yml`.
- **Roles**: en `roles/` (locales) + roles de Galaxy en `requirements.yml` (versiones **fijadas** para reproducibilidad).
- **Playbooks principales**:
  - `playbook.yml` → hosts remotos, un play por grupo del inventario: `nas` (`main`, `server`, `ssh`, `nas`, `dockstarter`) y `vps` (`main`, `server`, `ssh`).
  - `laptop.yml` → portátil local (`hosts: 127.0.0.1`, `connection: local`, roles `main`, `laptop`, `develop`, `claude`, `gantsign.visual-studio-code`).
  - `playbook-upgrade.yml` → upgrade de paquetes de todos los hosts + DockStarter (ejecutado por `upgrade.sh`).
- **CI** (`.github/workflows/ci.yml`): `ansible-lint` + `--syntax-check` + `molecule test` (matrix de roles: `claude`, `main`, `ssh`, `server`, `nas`, `develop`) con Docker.
- **`ansible.cfg`**: `inventory = inventories/`, `roles_path = roles:.ansible/roles:~/.ansible/roles`, `collections_path = .ansible/collections:~/.ansible/collections`, `pipelining = True`, `timeout = 30`. Roles y colecciones de Galaxy se instalan en `.ansible/` (gitignored) vía `install.sh`; las herramientas (ansible-core, ansible-lint, molecule) están fijadas en `requirements-dev.txt`.
- **Nota importante**: el directorio de trabajo debe tener permisos `755` (no world-writable), de lo contrario Ansible **ignora** `ansible.cfg`.

## Principios fundamentales

1. **Idempotencia**: ejecutar un playbook dos veces debe producir el mismo estado. Usa módulos de alto nivel (`ansible.builtin.apt`, `ansible.builtin.copy`, `ansible.builtin.template`, `ansible.builtin.systemd`) en lugar de `command`/`shell` cuando exista un módulo adecuado.
2. **FQCN siempre**: usa el nombre completo del módulo (`ansible.builtin.apt`, `community.general.docker_container`), nunca el corto (`apt`).
3. **Nombres de tarea descriptivos**: cada tarea debe empezar por un verbo en mayúscula y describir el resultado (`name: Install nginx`, `name: Enable and start sshd`).
4. **Declarativo**: describe el **estado deseado**, no los pasos imperativos.
5. **Menos es más**: prefiere un módulo idempotente a tres tareas `shell`.
6. **Seguridad por defecto**: nunca escribas secretos en claro; usa Vault + `no_log`.

## Estructura de un Playbook

```yaml
---
- name: Nombre descriptivo del play (qué se logra)
  hosts: grupo_o_host        # p. ej. all, nas, 127.0.0.1
  become: true               # escalar privilegios (sudo)
  become_user: root
  gather_facts: true         # false si no necesitas facts (ahorra tiempo)
  connection: local          # solo para ejecución local (laptop.yml)
  vars:
    app_port: 8080
  tasks:
    - name: Instalar dependencias base
      ansible.builtin.apt:
        name: "{{ base_packages }}"
        state: present
      tags: [packages]

    - name: Desplegar configuración
      ansible.builtin.template:
        src: app.conf.j2
        dest: /etc/app/app.conf
        owner: root
        group: root
        mode: "0644"
      notify: Recargar app
      tags: [config]

  handlers:
    - name: Recargar app
      ansible.builtin.systemd:
        name: app
        state: reloaded
```

### Buenas prácticas de playbook

- **Un play por objetivo/rol de host**. No mezcles lógica de "instalar" y "configurar" en tareas sueltas si puedes encapsularlas en un rol.
- **`gather_facts: false`** cuando no uses variables `ansible_*` (acelera mucho en inventarios grandes).
- **`check_mode`**: todo lo que escribas debe soportar `--check` (dry-run). Los módulos de alto nivel lo soportan; `command`/`shell` requieren `check_mode: false` explícito o no se ejecutarán en dry-run.
- **`diff: true`** (`--diff`) para ver cambios en `template`/`copy`/`lineinfile`.
- **Tags** para ejecutar subconjuntos: `ansible-playbook playbook.yml --tags packages` o `--skip-tags config`.
- **`any_errors_fatal: true`** en plays críticos para abortar si un host falla.
- **`serial`** para despliegues por oleadas: `serial: "20%"`.

## Estructura de un Rol

```
roles/mirol/
├── defaults/main.yml      # Variables con baja prioridad (sobrescribibles por el usuario)
├── vars/main.yml          # Variables del rol (alta prioridad, NO sobrescribibles fácilmente)
├── tasks/main.yml         # Tareas principales
├── handlers/main.yml      # Handlers (notificados con `notify`)
├── templates/             # Plantillas Jinja2 (*.j2)
├── files/                 # Archivos estáticos
├── meta/main.yml          # Dependencias, galaxy_info, requirements
├── molecule/              # Tests de Molecule (este proyecto usa molecule/)
└── README.md
```

### Jerarquía de variables (de menor a mayor prioridad)

1. `defaults/main.yml` (del rol)
2. Inventory group_vars/all
3. Inventory group_vars/<grupo>
4. Inventory host_vars/<host>
5. `vars/` del playbook
6. `vars/main.yml` (del rol)
7. `set_fact` / `vars` en tareas
8. Variables de play (`vars:`)
9. Variables extraídas de facts
10. **`-e` / `--extra-vars`** (máxima prioridad)

> **Regla**: pon valores por defecto en `defaults/` para que el usuario pueda sobrescribirlos; reserva `vars/` para constantes internas del rol.

### `meta/main.yml`

```yaml
---
galaxy_info:
  author: tu-usuario
  description: Rol para ...
  license: MIT
  min_ansible_version: "2.14"
  platforms:
    - name: Ubuntu
      versions: [jammy, noble]
  galaxy_tags: [sysadmin]
dependencies: []
```

## Idempotencia (lo más importante)

- **Usa módulos idempotentes**: `apt`, `yum`, `copy`, `template`, `file`, `systemd`, `service`, `user`, `mount`, `lineinfile`, `blockinfile`, `cron`.
- **Evita `command`/`shell`** salvo que no exista módulo. Si los usas:
  - Añade `changed_when` y `failed_when` para controlar el estado.
  - Añade `check_mode: false` si no soportan dry-run.
  - Usa `creates:`/`removes:` para saltar si el resultado ya existe.
- **`copy`/`template`** son idempotentes si defines `owner`, `group`, `mode`.
- **`lineinfile`/`blockinfile`** para editar configs sin romper idempotencia (mejor que `sed` en `shell`).
- **Verifica idempotencia**: ejecuta el playbook dos veces; la segunda vez debe reportar `changed=0`.

### Ejemplo: evitar anti-patrón `shell`

```yaml
# MAL (no idempotente, usa shell)
- name: Configurar límite
  ansible.builtin.shell: echo "* soft nofile 65535" >> /etc/security/limits.conf

# BIEN (idempotente)
- name: Configurar límite de archivos
  ansible.builtin.lineinfile:
    path: /etc/security/limits.conf
    regexp: '^\* soft nofile'
    line: '* soft nofile 65535'
    state: present
```

## Handlers

- Se ejecutan **al final** del play, **una sola vez** aunque se notifiquen varias veces.
- Se notifican con `notify: Nombre del handler`.
- Úsalos para **reinicio/recarga de servicios** tras cambiar su config.
- Nómbralos de forma inequívoca (el nombre es la clave de notificación).

```yaml
tasks:
  - name: Desplegar nginx.conf
    ansible.builtin.template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: Recargar nginx

handlers:
  - name: Recargar nginx
    ansible.builtin.systemd:
      name: nginx
      state: reloaded
```

## Variables, condicionales y bucles

```yaml
- name: Instalar paquetes según la distro
  ansible.builtin.package:
    name: "{{ pkgs }}"
    state: present
  vars:
    pkgs: "{{ ansible_facts['os_family'] == 'Debian' ? ['nginx'] : ['httpd'] }}"

- name: Tarea condicional
  ansible.builtin.debug:
    msg: "Solo en producción"
  when:
    - env == 'prod'
    - ansible_facts['distribution'] == 'Ubuntu'

- name: Iterar sobre una lista
  ansible.builtin.file:
    path: "/data/{{ item }}"
    state: directory
    mode: "0755"
  loop: "{{ data_dirs }}"
  loop_control:
    label: "{{ item }}"

- name: Iterar sobre un diccionario
  ansible.builtin.debug:
    msg: "{{ item.key }} = {{ item.value }}"
  loop: "{{ my_dict | dict2items }}"
```

- **`when`** acepta listas (AND implícito) y expresiones Jinja2.
- **`loop`** (antes `with_items`): usa `loop_control.label` para salida legible.
- **Filtros útiles**: `default`, `| to_json`, `| from_yaml`, `| dict2items`, `| items2dict`, `| map('extract', dict)`, `| selectattr`, `| first`, `| length`, `| regex_search`, `| community.general.version_compare`.

## Lookups

```yaml
- lookup('env', 'USER')                 # variable de entorno
- lookup('file', '/path/to/file')       # contenido de archivo
- lookup('password', '/path/.vault_pass length=16 chars=ascii_letters,digits')
- lookup('community.general.random_string', length=16)
- lookup('url', 'https://api.example.com/version')
- lookup('community.general.sshpipe', 'cmd', host='h')
```

## Plantillas (Jinja2)

- Archivos en `templates/` con extensión `.j2`.
- Accede a **facts** (`ansible_facts`), **variables** y **lookups**.
- Control de flujo: `{% for %}`, `{% if %}`, `{% set %}`.
- **Siempre** define `owner`, `group`, `mode` en la tarea `template` para idempotencia.

```jinja2
# templates/sshd_config.j2
Port {{ sshd_port | default(22) }}
PermitRootLogin {{ 'yes' if allow_root else 'no' }}
{% for user in allowed_users %}
AllowUsers {{ user }}
{% endfor %}
```

## Privilegios y conexiones

- **`become: true`** (sudo) a nivel de play, task o rol. `become_user`, `become_method` (sudo/su/doas).
- **`connection:`**: `local`, `ssh` (por defecto), `paramiko`, `docker`, `k8s`, `network_cli`.
- **`delegate_to:`** para ejecutar una tarea en otro host (p. ej. el control node):
  ```yaml
  - name: Crear imagen en el host de control
    ansible.builtin.command: docker build ...
    delegate_to: localhost
    become: false
  ```
- **`run_once: true`** para ejecutar una tarea una sola vez en el primer host.
- **`serial`** y **`max_fail_percentage`** para despliegues controlados.

## Gestión de secretos (Ansible Vault)

- **Nunca** escribas contraseñas, tokens o claves en claro en el repositorio.
- Cifra archivos completos: `ansible-vault encrypt inventories/vault.yml`.
- Edita: `ansible-vault edit inventories/vault.yml`.
- Clave en `~/.vault_pass` (gitignored), inyectada con `ANSIBLE_VAULT_PASSWORD_FILE` (no se fija en `ansible.cfg`).
- **`no_log: true`** en tareas que manejen secretos para evitar que aparezcan en el log.
- **Vault IDs múltiples** para cifrar con distintas claves (rotación): `--vault-id key1@file1 --vault-id key2@file2`.
- **`ansible-vault encrypt_string`** para cifrar un valor individual y pegarlo como `!vault |` literal.
- En este proyecto: `ansible_ssh_pass` y `ansible_become_pass` viven en `inventories/vault.yml` (cifrado).

```yaml
# inventories/vault.yml (CIFRADO, se commitea cifrado)
all:
  vars:
    ansible_ssh_pass: !vault |
          $ANSIBLE_VAULT;1.1;AES256;...
    ansible_become_pass: !vault |
          $ANSIBLE_VAULT;1.1;AES256;...
```

## Depuración y troubleshooting

### Flags útiles de `ansible-playbook`

| Flag | Uso |
|------|-----|
| `--check` | Dry-run, no aplica cambios |
| `--diff` | Muestra diferencias en `template`/`copy`/`lineinfile` |
| `-v` / `-vv` / `-vvv` / `-vvvv` | Verboacidad creciente (`-vvvv` muestra datos de conexión) |
| `--step` | Pide confirmación antes de cada tarea |
| `--start-at-task="Nombre"` | Reanuda desde una tarea concreta |
| `--limit <host>` | Limita a un host/grupo |
| `--tags` / `--skip-tags` | Filtra por tags |
| `--list-tasks` / `--list-hosts` | Lista tareas/hosts sin ejecutar |
| `--syntax-check` | Comprueba sintaxis sin ejecutar |
| `--forks N` | Paralelismo (por defecto 5) |
| `--flush-cache` | Refresca el cache de facts |

### Técnicas de depuración

- **`ansible.builtin.debug`** para imprimir variables:
  ```yaml
  - name: Depurar variable
    ansible.builtin.debug:
      var: ansible_facts['interfaces']
  ```
- **`ansible.builtin.assert`** para validar suposiciones (falla con mensaje claro):
  ```yaml
  - name: Asegurar que la variable existe
    ansible.builtin.assert:
      that:
        - my_var is defined
        - my_var | length > 0
      fail_msg: "my_var no está definida o está vacía"
      success_msg: "OK"
  ```
- **`ansible -m ping`** para probar conectividad: `ansible all -m ping`.
- **`ansible all -m setup`** para ver los facts de un host.
- **`ansible all -m setup -a 'filter=ansible_facts[os_family]'`** para un fact concreto.
- **`-vvv`** para ver el comando SSH real y errores de conexión.
- **`ANSIBLE_DEBUG=1`** o `-vvvv` para depurar la conexión.
- **`gather_facts: false`** + `setup` manual si los facts son lentos o fallan.

### Errores comunes y causas

| Síntoma | Causa probable / solución |
|---------|---------------------------|
| `ERROR! the playbook ... could not be found` | Ruta relativa incorrecta; ejecuta desde la raíz o usa `-i` y ruta absoluta. |
| `couldn't resolve module/action` | FQCN incorrecto o colección no instalada (`ansible-galaxy collection install`). |
| `Failed to connect to the host via ssh` | Credenciales, `ansible_ssh_pass`/`ansible_user`, firewall, o `ansible.cfg` ignorado (permisos del directorio ≠ 755). |
| `become method ... not found` | `sudo`/`su` no instalado o `become_method` mal configurado. |
| Tarea reporta `changed` en cada ejecución | Falta de idempotencia: usa módulo idempotente, define `mode`/`owner`, o `changed_when`. |
| `The task includes an option with when inside of loop` | `when` dentro de `loop` está deprecado; muévelo fuera o usa `loop_control`. |
| Vault: `Attempting to use 'vault' secret but no vault passwords have been set` | Falta `vault_password_file` o `ANSIBLE_VAULT_PASSWORD_FILE`. |
| `ansible.cfg` no se aplica | El directorio de trabajo es world-writable (debe ser `755`). |
| Secretos en el log | Añade `no_log: true` a la tarea. |
| Molecule falla en CI | Docker disponible, imagen disponible; para systemd: `privileged`, `cgroupns_mode: host`. |

## Linting con ansible-lint

- Instala: `pip install ansible-lint`.
- Ejecuta: `ansible-lint` (usa el perfil por defecto) o `ansible-lint --profile production`.
- **Tags de reglas** (para `skip` o `--tags`): `idempotency`, `idiom`, `security`, `syntax`, `yaml`, `formatting`, `command-shell`, `deprecations`, `unpredictability`, `metadata`, `opt-in`, `experimental`, `core`, `unskippable`.
- Reglas frecuentes a respetar:
  - **`name`**: cada play y tarea debe tener un `name` descriptivo (empieza por mayúscula).
  - **`yaml`**: sintaxis YAML válida, sin tabs, `---` al inicio, sin líneas en blanco finales.
  - **`no-free-form`**: usa sintaxis `key: value` en módulos, no free-form (`apt: name=foo` → `apt: {name: foo}`).
  - **`risky-file-permissions`**: define `mode` en `copy`/`template`/`file`.
  - **`no-changed-when`**: en `command`/`shell`, define `changed_when`.
  - **`command-instead-of-module`**: usa módulo si existe.
  - **`jinja`**: espacios en `{{ }}` (`{{ var }}`, no `{{var}}`).
  - **`var-naming`**: nombres de variables en minúsculas con `_`.
  - **`schema`**: estructura de rol/playbook válida.
- **Saltar una regla** (con justificación):
  ```yaml
  - name: Tarea que necesita shell
    ansible.builtin.shell: ...
    # noqa: command-instead-of-module
  ```
  O a nivel de play: `skip_ansible_lint` en `tags`.
- **Configuración**: `.ansible-lint` o sección en `ansible.cfg` para `profile`, `exclude_paths`, `skip_list`, `warn_list`.

## Testing con Molecule

- Molecule prueba roles en contornos aislados (Docker).
- Estructura: `roles/<rol>/molecule/<escenario>/` con `molecule.yml`, `converge.yml`, `verify.yml`, `prepare.yml`.
- Comandos:
  - `molecule list` — lista escenarios.
  - `molecule converge` — aplica el rol.
  - `molecule verify` — ejecuta asserts (con `assert` o `pytest`).
  - `molecule test` — ciclo completo (create → converge → verify → destroy).
  - `molecule cleanup` / `molecule destroy` — limpia contenedores.
- En este proyecto: `molecule test` corre en CI con el driver **Docker** para los roles `claude`, `main`, `ssh`, `server`, `nas`, `develop`.
- **`verify.yml`** típico:
  ```yaml
  - name: Verificar estado
    hosts: all
    tasks:
      - name: El servicio está activo
        ansible.builtin.assert:
          that:
            - item is active
          quiet: true
        loop: "{{ ansible_facts['services'] | select('defined') | list }}"
  ```

## CI/CD (GitHub Actions)

Patrón recomendado (ya presente en `.github/workflows/ci.yml`):

```yaml
name: CI
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - run: pip install ansible ansible-lint
      - run: ansible-galaxy install -r requirements.yml
      - run: ansible-lint
      - run: |
          ansible-playbook --syntax-check playbook.yml
          ansible-playbook --syntax-check laptop.yml
  molecule:
    runs-on: ubuntu-latest
    strategy:
      matrix: { role: [claude, main, ssh, server, nas, develop] }
    steps:
      - uses: actions/checkout@v4
      - run: pip install -r requirements-dev.txt
      - run: ansible-galaxy install -r requirements.yml
      - working-directory: roles/${{ matrix.role }}
        run: molecule test
```

## Comandos de referencia rápida

```bash
# Bootstrap
./install.sh && source .venv/bin/activate

# Ejecutar
ansible-playbook playbook.yml                 # hosts remotos
ansible-playbook laptop.yml                   # portátil local
./upgrade.sh [--check] [--diff] [--limit host]

# Probar conectividad / facts
ansible all -m ping
ansible all -m setup -a 'filter=ansible_facts[os_family]'

# Lint y sintaxis
ansible-lint
ansible-playbook --syntax-check playbook.yml

# Vault
ansible-vault edit inventories/vault.yml
ansible-vault encrypt inventories/vault.yml
ansible-vault decrypt inventories/vault.yml
ansible-vault encrypt_string 'mi-secreto'

# Galaxy
ansible-galaxy role install -r requirements.yml
ansible-galaxy collection install community.general
ansible-galaxy role create mirol

# Molecule
cd roles/main && molecule test
```

## Checklist antes de entregar un playbook/rol

- [ ] **Idempotente**: segunda ejecución → `changed=0`.
- [ ] **FQCN** en todos los módulos.
- [ ] **`name`** descriptivo en cada play y tarea.
- [ ] **`owner`/`group`/`mode`** definidos en `copy`/`template`/`file`.
- [ ] **Handlers** para reinicios/recargas de servicios.
- [ ] **Tags** para ejecutar subconjuntos.
- [ ] **Secretos** en Vault + `no_log: true` (nunca en claro).
- [ ] **`when`** correcto (sin `when` dentro de `loop`).
- [ ] **`check_mode`** soportado (dry-run funciona).
- [ ] **`ansible-lint`** pasa sin errores.
- [ ] **`--syntax-check`** pasa.
- [ ] **Molecule** (si aplica) pasa.
- [ ] **Variables** en `defaults/` (sobrescribibles) vs `vars/` (constantes).
- [ ] **`gather_facts`** solo si se usan facts.
- [ ] **README** del rol actualizado.

## Estilo de respuesta

- Responde en **español** (el proyecto usa español en comentarios y documentación), manteniendo términos técnicos en inglés cuando sea lo estándar.
- Cuando propongas cambios, muestra el **código YAML completo** listo para pegar, con comentarios explicativos.
- Si hay varias opciones, recomienda la **mejor práctica** y explica brevemente por qué.
- Prioriza **idempotencia, seguridad y legibilidad** por encima de la concisión.
- Si detectas un anti-patrón (p. ej. `shell` donde hay módulo, secreto en claro, falta de `mode`), señálalo y ofrece la corrección.