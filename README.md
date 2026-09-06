# omarchy-idle-tuner

Adds a "Suspend After" idle timer to Omarchy -- something the shell doesn't have out of the box -- and puts it, plus the existing screensaver/lock timers, in one menu.

For Omarchy (Hyprland).

## What it does

- **Screensaver After / Lock After**: same fields Omarchy's shell already reads (`idle.screensaver` / `idle.lock` in `~/.config/omarchy/shell.json`). This tool just gives you a quick menu to change them.
- **Suspend After**: a real gap in Omarchy -- there's no built-in way to suspend the machine after N minutes of inactivity. This runs a second, dedicated `hypridle` instance (its own systemd `--user` service, `omarchy-idle-suspend.service`) that just calls `systemctl suspend` on timeout. It's kept fully separate from any other `hypridle` instance (e.g. a keyboard-backlight one) so it can't be silently overwritten by unrelated tooling. The screen gets locked before suspend the same way it always does on this system (via logind's sleep hook), so there's nothing extra to configure there.
- Respects the usual idle inhibitors (a video playing in a browser, etc.) -- it doesn't force `ignore_dbus_inhibit`/`ignore_systemd_inhibit`, so anything that legitimately holds an idle-inhibit lock will stop the suspend timer same as it would stop a screensaver.

## Requirements

- Omarchy
- `jq`
- `hypridle` (ships with Omarchy)

Tested only on a MacBook Air/Pro M2 (Apple Silicon) running Omarchy via Asahi Linux. Should work on any Omarchy/Hyprland system.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Inspiractus01/omarchy-idle-tuner/main/install.sh | bash
```

Or clone it first if you'd rather read the script before running it:

```bash
git clone https://github.com/Inspiractus01/omarchy-idle-tuner.git
cd omarchy-idle-tuner
./install.sh
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/Inspiractus01/omarchy-idle-tuner/main/uninstall.sh | bash
```

## Use

Open the Omarchy menu (`SUPER+SPACE`), search "Idle Timing". You can set:

- Screensaver After: 30s / 1 / 2.5 / 5 / 10 min
- Lock After: 1 / 2 / 5 / 10 / 30 min
- Suspend After: Off / 1 / 2 / 5 / 10 / 20 / 30 / 60 min

Or from the terminal:

```bash
omarchy-idle-tuner get
omarchy-idle-tuner set screensaver 150
omarchy-idle-tuner set lock 300
omarchy-idle-tuner set suspend 1200   # seconds, or "off"
```

Suspend-after-idle stays off until you set it explicitly.

## License

MIT
