--[[ Awesome WM configuration ]] --

-- ░░░ Required Libraries ░░░
pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
local xresources = require("beautiful.xresources")
xresources.set_dpi(240)

require("awful.hotkeys_popup.keys")

-- ░░░ Theme + Config ░░░
local config   = require("theme_config")
local modkey   = "Mod3" -- override
local terminal = config.terminal
local browser  = config.browser
local editor   = config.editor
local vi_focus = config.vi_focus

-- ░░░ Error Handling ░░░
do
   local in_error = false
   local log_path = os.getenv("HOME") .. "/.cache/awesome/errors.log"
   awesome.connect_signal("debug::error", function(err)
      if in_error then return end
      in_error = true
      local msg = tostring(err)
      local log_file = io.open(log_path, "a")
      if log_file then
         log_file:write(os.date("[%Y-%m-%d %H:%M:%S] "), msg, "\n\n")
         log_file:close()
      end
      awful.spawn.with_shell("printf '%s' \"" ..
         msg:gsub('"', '\\"'):gsub("\n", "\\n") .. "\" | xclip -selection clipboard")
      naughty.notify { preset = naughty.config.presets.critical, title = "Oops, an error happened!", text = msg }
      in_error = false
   end)
end

-- ░░░ One-Time Background Processes ░░░
local function run_once(cmds)
   for _, cmd in ipairs(cmds) do
      awful.spawn.with_shell(("pgrep -u $USER -fx '%s' > /dev/null || (%s)"):format(cmd, cmd))
   end
end
run_once({ "urxvtd", "unclutter -root" })

-- ░░░ Keymap + Layout Setup ░░░
awful.spawn.with_shell("setxkbmap ch de")
awful.spawn.with_shell("~/.config/awesome/keymap.sh")

-- ░░░ Screen Setup (xrandr etc.) — MUST COME BEFORE APP LAUNCH ░░░
awful.spawn.with_shell("~/.config/awesome/screen.sh")

-- ░░░ Screen Mapping Debug (optional, temporary) ░░░
for s in screen do
   local outputs = ""
   for name, _ in pairs(s.outputs or {}) do
      outputs = outputs .. name .. ": Screen" .. s.index .. "\n"
   end
   naughty.notify { title = "Screen Mapping", text = outputs }
end

-- ░░░ Load Theme, Bars, Tags ░░░
require("screen")
awful.screen.connect_for_each_screen(function(s)
   beautiful.at_screen_connect(s)
end)

-- ░░░ Load Menu & Mouse ░░░
awful.util.mymainmenu = require("menu")
clientbuttons = require("mouse")

-- ░░░ Load Keys and Client Rules ░░░
local keys = require("keys")
root.keys(keys.global)

require("clients") {
   clientkeys    = keys.client,
   clientbuttons = keys.clientbuttons,
   vi_focus      = keys.vi_focus,
}

-- ░░░ Autorun Apps (wezterm, dolphin, etc.) — AFTER screen setup ░░░
-- awful.spawn.with_shell("sleep 1 && ~/.config/awesome/autorun.sh")

-- ░░░ Load Widgets ░░░
require("widget_discordian")
