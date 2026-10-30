#!/usr/bin/env bash
# Instala los presets de IA.
#
#   ./install.sh                       configura esta máquina (variables del fleet)
#   ./install.sh <proyecto>            además copia los presets al proyecto
#   ./install.sh <proyecto> --force    sobrescribe los archivos que ya existan
set -euo pipefail

PRESETS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/ai-presets"
CONFIG="$CONFIG_DIR/fleet.env"
MARKER="# ai-presets fleet env"
PRESETS=(.claude .agents .codex .github/workflows)

TARGET=""
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) TARGET="$arg" ;;
  esac
done

# 1. Configuración de la máquina
mkdir -p "$CONFIG_DIR"
if [ -f "$CONFIG" ]; then
  echo "✓ $CONFIG ya existe (no se toca)"
else
  cp "$PRESETS_DIR/fleet.env.example" "$CONFIG"
  echo "✓ creado $CONFIG — edítalo si tu máquina no usa los valores por defecto"
fi

for rc in "$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || [ "$rc" = "$HOME/.profile" ] || continue
  if grep -qF "$MARKER" "$rc" 2>/dev/null; then
    echo "✓ $rc ya carga la configuración"
  else
    # shellcheck disable=SC2016  # $HOME se expande al cargar el rc, no aquí
    printf '\n%s\n[ -f "$HOME/.config/ai-presets/fleet.env" ] && . "$HOME/.config/ai-presets/fleet.env"\n' "$MARKER" >> "$rc"
    echo "✓ $rc ahora carga la configuración"
  fi
done

# 2. Copia de presets al proyecto
[ -n "$TARGET" ] || { echo "Listo. Abre una terminal nueva para cargar las variables."; exit 0; }
[ -d "$TARGET" ] || { echo "✗ no existe el directorio $TARGET" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
[ "$TARGET" != "$PRESETS_DIR" ] || { echo "✗ el destino es este mismo repo" >&2; exit 1; }

copied=0
skipped=()
for dir in "${PRESETS[@]}"; do
  [ -d "$PRESETS_DIR/$dir" ] || continue
  while IFS= read -r -d '' src; do
    rel="${src#"$PRESETS_DIR"/}"
    dst="$TARGET/$rel"
    if [ -e "$dst" ] && [ "$FORCE" -eq 0 ]; then
      skipped+=("$rel")
      continue
    fi
    mkdir -p "$(dirname "$dst")"
    cp -p "$src" "$dst"
    copied=$((copied + 1))
  done < <(find "$PRESETS_DIR/$dir" -type f -print0)
done

echo "✓ $copied archivos copiados a $TARGET"
if [ "${#skipped[@]}" -gt 0 ]; then
  echo "⚠ ${#skipped[@]} archivos ya existían y no se tocaron (usa --force para sobrescribir):"
  printf '    %s\n' "${skipped[@]}"
fi
echo "Recuerda adaptar .github/workflows/ al proyecto (DJANGO_SETTINGS_MODULE, nombres de DB, etc.)."
