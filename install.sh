#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/Inspiractus01/omarchy-idle-tuner/main"
BIN_DIR="$HOME/.local/bin"
MENU_FILE="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

echo "==> Checking dependencies"
command -v jq >/dev/null || { echo "jq not found. Install it: omarchy pkg add jq"; exit 1; }
command -v hypridle >/dev/null || { echo "hypridle not found. This needs Omarchy/Hyprland."; exit 1; }
[[ -f "$HOME/.config/omarchy/shell.json" ]] || { echo "~/.config/omarchy/shell.json not found. This needs Omarchy's shell."; exit 1; }

echo "==> Installing script to $BIN_DIR"
mkdir -p "$BIN_DIR"
curl -fsSL "$REPO_RAW/bin/omarchy-idle-tuner" -o "$BIN_DIR/omarchy-idle-tuner"
chmod 755 "$BIN_DIR/omarchy-idle-tuner"

echo "==> Adding menu entries"
mkdir -p "$(dirname "$MENU_FILE")"
if [[ ! -f "$MENU_FILE" ]]; then
  printf '{\n}\n' > "$MENU_FILE"
fi
if grep -q '"trigger.idle-tuner"' "$MENU_FILE"; then
  echo "    Already added, skipping."
else
  cp "$MENU_FILE" "$MENU_FILE.bak.$(date +%s)"
  SNIPPET_FILE="$(mktemp)"
  curl -fsSL "$REPO_RAW/menu.jsonc" -o "$SNIPPET_FILE"
  python3 - "$MENU_FILE" "$SNIPPET_FILE" <<'PY'
import sys
menu_path, snippet_path = sys.argv[1], sys.argv[2]
snippet = open(snippet_path).read().rstrip("\n")
text = open(menu_path).read()
idx = text.rstrip().rfind("}")
new_text = text[:idx].rstrip()
if new_text and not new_text.endswith(","):
    new_text += ","
new_text += "\n\n" + snippet + "\n}\n"
open(menu_path, "w").write(new_text)
PY
  rm -f "$SNIPPET_FILE"
  echo "    Added (backup: $MENU_FILE.bak.*)"
fi

echo "==> Done. Press SUPER+SPACE and search 'Idle Timing'."
echo "    Screensaver/lock apply immediately. Suspend-after-idle stays 'Off' until"
echo "    you pick a value from the menu (or run 'omarchy-idle-tuner set suspend <seconds>')."
