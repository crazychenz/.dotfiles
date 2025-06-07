-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

config.default_prog = { "powershell.exe" }

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = "Catppuccin Mocha"
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"

wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

config.leader = { key="a", mods="CTRL", timeout_milliseconds = 1000 }
config.disable_default_key_bindings = true
config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ 
	  key = "a",
	  mods = "LEADER|CTRL",
	  action = wezterm.action.SendKey { mods = 'CTRL', key = 'a' }
	},
	
	-- LEADER then 'r' for resize-pane mode.
    { key = 'r', mods = 'LEADER', action = wezterm.action.ActivateKeyTable { name = 'resize_pane', one_shot = false, }, },
	
	{ key = "\"", mods = "LEADER|SHIFT",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
	{ key = "%",mods = "LEADER|SHIFT",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
	{ key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
	{ key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
	{ key = "h", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
	{ key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
	{ key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
	{ key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
	{ key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
	{ key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
	{ key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
	{ key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
	{ key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
	{ key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
	{ key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
	{ key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
	{ key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
	{ key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
	{ key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
	{ key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
	{ key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
	{ key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
	{ key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},

	{ key = "Enter", mods="ALT",     action="ToggleFullScreen" },
	{ key ="v",  mods="SHIFT|CTRL",    action=wezterm.action.PasteFrom 'Clipboard'},
	{ key ="c",  mods="SHIFT|CTRL",    action=wezterm.action.CopyTo 'Clipboard'},
	{ key = "+", mods="SHIFT|CTRL",     action="IncreaseFontSize" },
	{ key = "-", mods="SHIFT|CTRL",     action="DecreaseFontSize" },
	{ key = "0", mods="SHIFT|CTRL",     action="ResetFontSize" },
}

config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

-- Finally, return the configuration to wezterm:
return config
