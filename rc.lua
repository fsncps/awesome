--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required librariesC

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- local wibox         = require("wibox")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
-- local lain          = require("lain")
--local menubar       = require("menubar")
-- local freedesktop   = require("freedesktop")
-- local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
xresources.set_dpi(240)

--
require("awful.hotkeys_popup.keys")
local config     = require("theme_config")
local modkey     = config.modkey
local altkey     = config.altkey
local terminal   = config.terminal
local browser    = config.browser
local editor     = config.editor
local vi_focus   = config.vi_focus
local cycle_prev = config.cycle_prev

-- }}}
-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify {
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
   }
end

-- Handle runtime errors after startup
-- Handle runtime errors after startup
do
   local in_error = false
   _ERROR_LOG = {}
   local log_path = os.getenv("HOME") .. "/.cache/awesome/errors.log"

   awesome.connect_signal("debug::error", function(err)
      if in_error then return end
      in_error = true

      local msg = tostring(err)
      table.insert(_ERROR_LOG, msg)

      -- Append to log file
      local log_file = io.open(log_path, "a")
      if log_file then
         log_file:write(os.date("[%Y-%m-%d %H:%M:%S] "), msg, "\n\n")
         log_file:close()
      end

      -- Copy last error to clipboard (first line only for sanity)
      awful.spawn.with_shell("printf '%s' \"" ..
         msg:gsub('"', '\\"'):gsub("\n", "\\n") .. "\" | xclip -selection clipboard")

      -- Show notification
      naughty.notify {
         preset = naughty.config.presets.critical,
         title = "Oops, an error happened!",
         text = msg
      }

      in_error = false
   end)
end


-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
   for _, cmd in ipairs(cmd_arr) do
      awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
   end
end

run_once({ "urxvtd", "unclutter -root" }) -- comma-separated entries


-- {{{ Menu
awful.util.mymainmenu = require("menu")

-- {{{ Screen
require("screen")
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- {{{ Mouse bindings
clientbuttons = require("mouse")
-- }}}

-- {{{ Clients
require("clients") {
   clientkeys = clientkeys,
   clientbuttons = clientbuttons,
   vi_focus = vi_focus
}
-- }}}
--
--KEYBOARD
awful.spawn.with_shell("setxkbmap ch de")

-- Load keybindings
local keys = require("keys")

-- Set keys
root.keys(keys.global)
client.connect_signal("request::default_keybindings", function()
   awful.keyboard.append_client_keybindings(keys.client)
end)

-- SCREENS
awful.spawn.with_shell("~/.screenlayout/awesome.sh")
