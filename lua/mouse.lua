-- mouse.lua
local awful = require("awful")
local gears = require("gears")

local modkey = "Mod4" -- or receive from config
local mytable = awful.util.table or gears.table

-- Global mouse bindings
root.buttons(mytable.join(
   awful.button({}, 3, function() awful.util.mymainmenu:toggle() end),
   awful.button({}, 4, awful.tag.viewnext),
   awful.button({}, 5, awful.tag.viewprev)
))

-- Client mouse bindings
local clientbuttons = mytable.join(
   awful.button({}, 1, function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
   end),
   awful.button({ modkey }, 1, function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      awful.mouse.client.move(c)
   end),
   awful.button({ modkey }, 3, function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      awful.mouse.client.resize(c)
   end)
)

return clientbuttons
