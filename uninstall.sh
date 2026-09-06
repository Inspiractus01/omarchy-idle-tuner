#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
SUSPEND_UNIT="$HOME/.config/systemd/user/omarchy-idle-suspend.service"
HYPRIDLE_SUSPEND_CONF="$HOME/.config/hypr/hypridle-suspend.conf"

echo "==> Stopping suspend-after-idle service"
systemctl --user stop omarchy-idle-suspend.service 2>/dev/null || true
systemctl --user disable omarchy-idle-suspend.service 2>/dev/null || true

echo "==> Removing files"
rm -f "$SUSPEND_UNIT" "$HYPRIDLE_SUSPEND_CONF"
rm -f "$BIN_DIR/omarchy-idle-tuner"
systemctl --user daemon-reload 2>/dev/null || true

echo "==> Done."
echo "    Screensaver/lock timing (~/.config/omarchy/shell.json 'idle') was left as-is --"
echo "    that's Omarchy's own setting, not owned by this tool."
echo "    Remove the 'trigger.idle-tuner*' lines from"
echo "    ~/.config/omarchy/extensions/omarchy-menu.jsonc yourself if you added them."
echo "    ~/.config/omarchy/idle-suspend.conf was left in place."
