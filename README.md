# ai_skills_project

Stack principal de IA que usamos como presets para nuestros proyectos.

| Carpeta | Contenido |
| --- | --- |
| `.agents/skills/` | Skills agnósticas (Codex / OpenAI agents) |
| `.claude/` | Skills, agentes, comandos y `settings.json` de Claude Code |
| `.codex/` | Configuración y agentes de Codex |
| `.github/workflows/` | Workflows de CI de referencia — se adaptan en cada proyecto |

Origen: [WeAreProjectApp/projectapp](https://github.com/WeAreProjectApp/projectapp) @ `7f1a845`,
sin hooks locales ni las skills propias del negocio ProjectApp (propuestas, clientes,
integridad de datos del Gestor, blog, calculadora de requerimientos).

Varias skills de operación (git-commit, merge-when-green, fake-data-refresh, playwright-validation,
tailscale-connect, …) asumen la infraestructura del fleet: `~/webapps/<proyecto>`,
`~/webapps/vps-ops-toolkit` y Tailscale.
