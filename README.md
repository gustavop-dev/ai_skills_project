# ai_skills_project

Stack principal de IA que usamos como presets para nuestros proyectos.

| Carpeta | Contenido |
| --- | --- |
| `.agents/skills/` | Skills agnósticas (Codex / OpenAI agents) |
| `.claude/` | Skills, agentes, comandos, hooks y `settings.json` de Claude Code |
| `.codex/` | Configuración y agentes de Codex |
| `.github/workflows/` | Workflows de CI de referencia — se adaptan en cada proyecto |

## Uso

```bash
git clone https://github.com/gustavop-dev/ai_skills_project.git
cd ai_skills_project

./install.sh                         # una vez por máquina: configura las variables del fleet
./install.sh ~/webapps/mi_proyecto   # copia los presets a un proyecto (no sobrescribe)
./install.sh ~/webapps/mi_proyecto --force   # sobrescribe lo que ya exista
```

Después de copiar, adapta `.github/workflows/` al proyecto (`DJANGO_SETTINGS_MODULE`,
nombres de base de datos, jobs que no apliquen).

## Configuración del fleet

Las skills de operación (git-commit, git-sync, merge-when-green, fake-data-refresh,
playwright-validation, tailscale-connect, dev-up, …) usan estas variables en vez de
rutas fijas:

| Variable | Por defecto | Para qué |
| --- | --- | --- |
| `FLEET_PROJECTS_ROOT` | `$HOME/webapps` | Raíz de los clones de proyectos |
| `OPS_ROOT` | `$FLEET_PROJECTS_ROOT/vps-ops-toolkit` | Clon del toolkit de operación |
| `FLEET_SSH_USER` | `ryzepeck` | Usuario de `tailscale ssh` en los VPS |
| `FLEET_VPS_ROOT` | `/home/$FLEET_SSH_USER/webapps` | Si existe localmente, dev-up/dev-down se niegan a correr |
| `FLEET_HOST_ALIASES` | `srv571894=vps-projectapp-staging,…` | `hostname=alias` de los VPS |

Se definen en `~/.config/ai-presets/fleet.env` (lo crea `install.sh` a partir de
`fleet.env.example`), que se carga desde `~/.profile` y `~/.bashrc`; así lo heredan
Claude Code y Codex. Además, en Claude Code el hook `SessionStart`
(`.claude/hooks/fleet-env.sh`) exporta las mismas variables en cada sesión, con los
valores por defecto si no hay archivo de configuración.

Si el proyecto destino ya tenía `.claude/settings.json`, `install.sh` no lo pisa:
agrega a mano el hook `SessionStart` de este repo.

## Origen

[WeAreProjectApp/projectapp](https://github.com/WeAreProjectApp/projectapp) @ `7f1a845`,
sin las skills propias del negocio ProjectApp (propuestas, clientes, integridad de datos
del Gestor, blog, calculadora de requerimientos).
