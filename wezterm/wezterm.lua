-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set the starting position
local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {
    position = { x = 200, y = 100 },  -- starting position in pixels
  })
end)


-- This is where you actually apply your config choices
config.initial_rows = 45
config.initial_cols = 180

--Set the font / theme 
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14
config.color_scheme = 'AdventureTime'

config.default_prog = { "C:/Program Files/nu/bin/nu.exe" }


-- Keybindings
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
  -- Tab creation / splitting
  {
    -- Create a new tab
    mods = "LEADER",
    key = "c",
    action = wezterm.action.SpawnTab "CurrentPaneDomain"
  },
  {
    -- Close the current tab
    mods = "LEADER",
    key = "x",
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  {
    -- Split the current pane horizontally
    mods = "LEADER",
    key = "p",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
  },
  {
    -- Split the current pane vertically
    mods = "LEADER",
    key = "P",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
  },
  
  -- Pane Navigation
  {
    -- Move to pane above
    mods = "LEADER",
    key = "w",
    action = wezterm.action.ActivatePaneDirection "Up"
  },
  {
    -- Move to pane below
    mods = "LEADER",
    key = "s",
    action = wezterm.action.ActivatePaneDirection "Down"
  },
  {
    -- Move to pane on the left
    mods = "LEADER",
    key = "a",
    action = wezterm.action.ActivatePaneDirection "Left"
  },
  {
    -- Move to pane on the right
    mods = "LEADER",
    key = "d",
    action = wezterm.action.ActivatePaneDirection "Right"
  },

  -- Pane Sizing
  {
    --  Decrease pane width
    mods = "LEADER",
    key = "LeftArrow",
    action = wezterm.action.AdjustPaneSize { "Left", 5 }
  },
  {
    --  Increase pane width
    mods = "LEADER",
    key = "RightArrow",
    action = wezterm.action.AdjustPaneSize { "Right", 5 }
  },
  {
    --  Decrease pane height
    mods = "LEADER",
    key = "UpArrow",
    action = wezterm.action.AdjustPaneSize { "Up", 5 }
  },
  {
    -- Increase pane height
    mods = "LEADER",
    key = "DownArrow",
    action = wezterm.action.AdjustPaneSize { "Down", 5 }
  }
}

-- Configure 0 - 9 to switch to relevant tab
for i = 0, 9 do
  table.insert(config.keys, {
    mods = "LEADER",
    key = tostring(i),
    action = wezterm.action.ActivateTab(i)
  })
end

-- Configure tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true


-- Tmux Status
wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = ""
  local ARROW_FOREGROUND = { Foreground = { Color = '#000000' } }
  local prefix = ""

  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1f30a)  -- ocean wave
    SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  end

  -- Arrow colour based on if tab is first pane
  if window:active_tab():tab_id() ~= 0 then
    ARROW_FOREGROUND = { Foreground = { Color = "#333333" } }
  end

  window:set_left_status(wezterm.format {
    { Background = { Color = "#b7bdf8" } },
    { Text = prefix },
    ARROW_FOREGROUND,
    { Text = SOLID_LEFT_ARROW }
  })

end)



-- For example, changing the color scheme:
config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'AdventureTime'

config.default_prog = { "C:/Program Files/nu/bin/nu.exe" }

-- and finally, return the configuration to wezterm
return config
