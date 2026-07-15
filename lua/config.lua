-- theme_config.lua
local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful")

-- local theme_name = "copland" -- Pick your base theme here
local lain      = require("lain")

-- Initialize theme
beautiful.init(string.format("%s/.config/awesome/theme/theme.lua", os.getenv("HOME")))

-- Define globals
local M              = {}

M.modkey             = "Mod4"
M.altkey             = "Mod1"
M.terminal           = "wezterm"
M.browser            = "librewolf"
M.editor             = os.getenv("EDITOR") or "nvim"
M.vi_focus           = false
M.cycle_prev         = true

-- Set layouts
awful.layout.layouts = {
   -- awful.layout.suit.floating,
   awful.layout.suit.tile,
   -- awful.layout.suit.tile.left,
   -- awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   -- awful.layout.suit.fair,
   -- awful.layout.suit.fair.horizontal,
   -- awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   -- awful.layout.suit.max.fullscreen,
   -- awful.layout.suit.magnifier,
   -- awful.layout.suit.corner.nw,
   -- awful.layout.suit.corner.ne,
   -- awful.layout.suit.corner.sw,
   -- awful.layout.suit.corner.se,
}

-- specific layout config
-- lain.layout.termfair.nmaster           = 3
-- lain.layout.termfair.ncol              = 1
-- lain.layout.termfair.center.nmaster    = 3
-- lain.layout.termfair.center.ncol       = 1
-- lain.layout.cascade.tile.offset_x      = 2
-- lain.layout.cascade.tile.offset_y      = 32
-- lain.layout.cascade.tile.extra_padding = 5
-- lain.layout.cascade.tile.nmaster       = 5
-- lain.layout.cascade.tile.ncol          = 2


-- TAGS
awful.util.tagnames         = { "I", "II", "III" }

local mytable               = awful.util.table or gears.table
awful.util.taglist_buttons  = mytable.join(
   awful.button({}, 1, function(t) t:view_only() end),
   awful.button({ M.modkey }, 1, function(t)
      if client.focus then client.focus:move_to_tag(t) end
   end),
   awful.button({}, 3, awful.tag.viewtoggle),
   awful.button({ M.modkey }, 3, function(t)
      if client.focus then client.focus:toggle_tag(t) end
   end),
   awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Tasklist buttons
awful.util.tasklist_buttons = mytable.join(
   awful.button({}, 1, function(c)
      if c == client.focus then
         c.minimized = true
      else
         c:emit_signal("request::activate", "tasklist", { raise = true })
      end
   end),
   awful.button({}, 3, function()
      awful.menu.client_list({ theme = { width = 250 } })
   end),
   awful.button({}, 4, function() awful.client.focus.byidx(1) end),
   awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

-- Custom theme overrides
screen.connect_signal("request::wallpaper", function(s)
   gears.wallpaper.set("#210000", s)
end)

beautiful.font            = "FiraCode Nerd Font 10"
beautiful.icon_theme      = os.getenv("HOME") .. "/.local/share/icons/Gruvbox/"
beautiful.border_focus    = "#400000"
beautiful.titlebar_height = 60


return M
