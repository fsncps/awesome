-- screen.lua
local gears = require("gears")
local beautiful = require("beautiful")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      if type(wallpaper) == "function" then
         wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end)

-- No borders when only one tiled or maximized client
screen.connect_signal("arrange", function(s)
   local only_one = #s.tiled_clients == 1
   for _, c in pairs(s.clients) do
      if only_one and not c.floating or c.maximized or c.fullscreen then
         c.border_width = 0
      else
         c.border_width = beautiful.border_width
      end
   end
end)
