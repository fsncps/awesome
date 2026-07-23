-- menu.lua
local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local freedesktop = require("freedesktop")

local config = require("config")

local terminal = config.terminal
local editor = config.editor

local myawesomemenu = {
  {
    "Hotkeys",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { "Manual", string.format("%s -e man awesome", terminal) },
  { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
  { "Restart", awesome.restart },
  {
    "Quit",
    function()
      awesome.quit()
    end,
  },
}

local mymainmenu = freedesktop.menu.build({
  before = {
    { "Awesome", myawesomemenu, beautiful.awesome_icon },
  },
  after = {
    { "Open terminal", terminal },
  },
})
--
-- local mymainmenu = awful.menu({
--   items = {
--     { "awesome", myawesomemenu, beautiful.awesome_icon },
--     { "open terminal", terminal },
--     { "applications", appmenu.Appmenu },
--   },
-- })

-- Hide the menu when the mouse leaves it
mymainmenu.wibox:connect_signal("mouse::leave", function()
  if
    not mymainmenu.active_child
    or (mymainmenu.wibox ~= mouse.current_wibox and mymainmenu.active_child.wibox ~= mouse.current_wibox)
  then
    mymainmenu:hide()
  else
    mymainmenu.active_child.wibox:connect_signal("mouse::leave", function()
      if mymainmenu.wibox ~= mouse.current_wibox then
        mymainmenu:hide()
      end
    end)
  end
end)

return mymainmenu
