local wezterm = require 'wezterm'

return {
  font_size = 10.0,
  default_prog = { '/bin/bash', '--init-file', os.getenv('HOME') .. '/.local/bin/tmux-init.sh' },
  default_cursor_style = 'SteadyBlock',
  xcursor_theme = 'breeze_cursors',
  keys = {
    {
      key = 'Backspace',
      mods = 'CTRL',
      action = wezterm.action.SendString '\x17',  -- ^W, universal readline compat
    },
  },
}
