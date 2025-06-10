-- menu.lua
local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local freedesktop = require("freedesktop")

local terminal = "wezterm"
local editor = os.getenv("EDITOR") or "nvim"

local myawesomemenu = {
   { "Hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual",      string.format("%s -e man awesome", terminal) },
   { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
   { "Restart",     awesome.restart },
   { "Quit",        function() awesome.quit() end },
}

local mymainmenu = freedesktop.menu.build {
   before = {
      { "Awesome", myawesomemenu, beautiful.awesome_icon },
   },
   after = {
      { "Open terminal", terminal },
   }
}

-- Hide the menu when the mouse leaves it
mymainmenu.wibox:connect_signal("mouse::leave", function()
   if not mymainmenu.active_child or
       (mymainmenu.wibox ~= mouse.current_wibox and
          mymainmenu.active_child.wibox ~= mouse.current_wibox) then
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

