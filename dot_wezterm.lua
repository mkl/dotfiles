-- Managed by chezmoi - Catppuccin Mocha WezTerm config
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 13.0
config.initial_cols = 85
config.initial_rows = 36
config.audible_bell = 'Disabled'

-- Cmd+click opens URLs even when tmux mouse mode captures clicks
config.bypass_mouse_reporting_modifiers = 'CMD'
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.Nop,
  },
}

-- Tab bar styling - Catppuccin Mocha palette
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.tab_max_width = 32
config.window_frame = {
  font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' }),
  font_size = 12.0,
  active_titlebar_bg = '#1e1e2e',   -- base
  inactive_titlebar_bg = '#181825', -- mantle
}

config.colors = {
  tab_bar = {
    background = '#1e1e2e',           -- base
    active_tab = {
      bg_color = '#cba6f7',           -- mauve
      fg_color = '#1e1e2e',           -- base
    },
    inactive_tab = {
      bg_color = '#313244',           -- surface0
      fg_color = '#cdd6f4',           -- text
    },
    inactive_tab_hover = {
      bg_color = '#45475a',           -- surface1
      fg_color = '#cdd6f4',           -- text
    },
    new_tab = {
      bg_color = '#313244',           -- surface0
      fg_color = '#cdd6f4',           -- text
    },
    new_tab_hover = {
      bg_color = '#45475a',           -- surface1
      fg_color = '#cdd6f4',           -- text
    },
  },
}

return config
