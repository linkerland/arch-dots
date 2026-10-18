#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
    cat <<'USAGE'
Usage: ./install.sh [--skip-packages]

Install the Arch Linux packages and the local st/dmenu packages, back up managed
files, and copy the configuration into your home directory. Run as your normal user.
USAGE
}

install_packages=1
while (($#)); do
    case "$1" in
        --skip-packages) install_packages=0 ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

if [[ ! -f /etc/arch-release ]]; then
    printf 'This installer targets Arch Linux.\n' >&2
    exit 1
fi
if (( EUID == 0 )); then
    printf 'Run this script as your normal user; it uses sudo only for pacman.\n' >&2
    exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$script_dir/dotfiles"

if (( install_packages )); then
    if ! command -v sudo >/dev/null 2>&1; then
        printf 'sudo is required to install packages. Re-run with --skip-packages to copy configs only.\n' >&2
        exit 1
    fi
    packages=(
        adwaita-icon-theme bash-language-server base-devel brightnessctl clang dex
        fastfetch feh fontconfig git gtk3 harfbuzz i3-wm i3lock libx11 libxft libxinerama
        libxrender maim neovim network-manager-applet
        noto-fonts noto-fonts-emoji npm orchis-theme picom polybar python
        pkgconf python-lsp-server rust rust-analyzer shfmt shellcheck starship thunar
        ttf-dejavu-nerd ttf-hack tree-sitter-cli xclip xorg-xrdb xss-lock xterm libpulse
    )
    sudo pacman -S --needed "${packages[@]}"

    if ! pacman -Qq ttf-joypixels >/dev/null 2>&1; then
        if command -v yay >/dev/null 2>&1; then
            yay -S --needed ttf-joypixels
        else
            printf 'ttf-joypixels is an AUR dependency. Install it with an AUR helper, then rerun this script.\n' >&2
            exit 1
        fi
    fi

    if ! command -v makepkg >/dev/null 2>&1; then
        printf 'makepkg is required to build the st and dmenu packages.\n' >&2
        exit 1
    fi

    build_root="$(mktemp -d "${TMPDIR:-/tmp}/arch-dots-build.XXXXXX")"
    trap 'rm -rf -- "$build_root"' EXIT
    shopt -s nullglob
    for package_dir in st dmenu; do
        build_dir="$build_root/$package_dir"
        mkdir -p "$build_dir"
        cp -a "$script_dir/$package_dir/." "$build_dir/"
        printf 'Building %s from the checked-in sources with makepkg -cf...\n' "$package_dir"
        (cd "$build_dir" && makepkg -cf)

        package_archives=()
        for archive in "$build_dir"/*.pkg.tar.*; do
            [[ "$archive" == *-debug-* ]] && continue
            package_archives+=("$archive")
        done
        if ((${#package_archives[@]} == 0)); then
            printf 'makepkg did not produce an installable package for %s.\n' "$package_dir" >&2
            exit 1
        fi
        sudo pacman -U --needed "${package_archives[@]}"
    done
fi

stamp="$(date +%Y%m%d-%H%M%S)"
backup_root="$HOME/.local/share/arch-dots-backups/$stamp"
backed_up=0
mkdir -p "$HOME/Pictures"

while IFS= read -r -d '' source_file; do
    rel_path="${source_file#"$dotfiles_dir"/}"
    destination="$HOME/$rel_path"
    mkdir -p "$(dirname -- "$destination")"

    if [[ -e "$destination" || -L "$destination" ]]; then
        if ! cmp -s -- "$source_file" "$destination"; then
            mkdir -p "$(dirname -- "$backup_root/$rel_path")"
            cp -a -- "$destination" "$backup_root/$rel_path"
            backed_up=1
        fi
    fi

    if [[ "$rel_path" == ".config/fastfetch/config.jsonc" ]]; then
        python3 - "$source_file" "$destination" "$HOME" <<'PY'
from pathlib import Path
import json
import sys

source, destination, home = map(Path, sys.argv[1:])
text = source.read_text()
replacement = json.dumps(str(home / ".config/fastfetch/cat.txt"))[1:-1]
text = text.replace("__HOME__/.config/fastfetch/cat.txt", replacement)
destination.write_text(text)
PY
        chmod --reference="$source_file" "$destination"
    else
        install -m "$(stat -c '%a' "$source_file")" "$source_file" "$destination"
    fi
done < <(find "$dotfiles_dir" -type f -print0 | sort -z)

if (( backed_up )); then
    printf 'Previous versions saved under %s\n' "$backup_root"
fi
printf 'Dotfiles installed. Log out and back in, or reload i3 with Mod+Shift+C.\n'
printf 'On first Neovim launch, lazy.nvim will fetch the configured plugins.\n'
