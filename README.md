# arch-dots

Personal Arch Linux dotfiles for an i3/X11 desktop, with a charcoal and sage theme. The setup includes a mouse-friendly Neovim environment for Rust, Python, Bash, C, and Markdown, plus Fastfetch, Starship, Polybar, Picom, GTK, and Thunar settings.

## Install

```bash
git clone https://github.com/linkerland/arch-dots.git
cd arch-dots
./install.sh
```

The installer uses `sudo pacman` to install the listed Arch packages, backs up any managed files it will replace to `~/.local/share/arch-dots-backups/`, and then copies the dotfiles into place. Run it as your regular user. To copy configs without installing packages, use `./install.sh --skip-packages`.

Log out and back in to start or refresh the desktop session. Reload i3 with **Mod+Shift+C**. Neovim installs its locked plugins on first launch and needs network access for that initial setup.

## Notes

- `Mod+Shift+S` saves a fullscreen screenshot in `~/Pictures` with `maim`.
- The terminal wrapper prefers `st` at `/usr/sbin/st` or `/usr/bin/st`, and falls back to `xterm`. Install your preferred `st` build separately if you want it as the main terminal.
- The Polybar battery module uses `BAT1` and `ADP1`, matching the machine these settings came from. Change those names in `.config/polybar/config.ini` if your hardware reports different power-supply names.
- Wallpaper files and wallpaper-manager state are not included. Add your own wallpaper locally.
- Browser profiles, credentials, caches, logs, package build artifacts, and unrelated application data are intentionally excluded.
