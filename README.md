# dotfiles

Catppuccin Mocha-themed terminal configuration, managed by [chezmoi](https://www.chezmoi.io/).

## What's included

| Config | File | Templated |
|--------|------|-----------|
| Claude Code statusline | `~/.claude/statusline.sh` | No |
| tmux + Catppuccin via TPM | `~/.tmux.conf` | Yes (hostname) |
| Starship prompt | `~/.config/starship.toml` | Yes (hostname) |
| WezTerm (macOS) | `~/.wezterm.lua` | No |
| Lazygit | `~/.config/lazygit/config.yml` | No |
| Yazi file manager | `~/.config/yazi/theme.toml` | No |

## Quick start

```bash
# New machine — install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mkl/dotfiles
```

On first run, chezmoi will prompt for a short hostname (e.g. `mac_mini`, `macbook`) used in the starship prompt and tmux nested-session toggle.

The bootstrap script automatically installs: tmux, TPM + Catppuccin plugin, starship, jq, lazygit, yazi, and JetBrains Mono Nerd Font.

## Update

```bash
chezmoi update
```

## Dependencies

Installed automatically by the bootstrap script. Requires:
- **macOS**: Homebrew (installed if missing)
- **Linux**: apt-based distro (Ubuntu/Debian)
