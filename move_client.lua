local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local client = _G.client
local screen = _G.screen

local move_client = {}

function move_client.move_client_bydirection(dir)
   local c = client.focus
   if not c then return end

   -- Store x/y before
   local geo_before = c:geometry()
   local x_before = geo_before.x
   local y_before = geo_before.y

   -- Do the swap
   awful.client.swap.bydirection(dir, c, true)

   -- Check movement after layout settles
   gears.timer.delayed_call(function()
      local c2 = client.focus
      if not c2 then return end

      local geo_after = c2:geometry()
      local x_after = geo_after.x
      local y_after = geo_after.y

      local moved = (x_before ~= x_after) or (y_before ~= y_after)

      if not moved then
         local next_screen
         if dir == "left" then
            next_screen = c.screen.index % screen.count() + 1
         elseif dir == "right" then
            next_screen = (c.screen.index - 2 + screen.count()) % screen.count() + 1
         end

         if next_screen then
            c:move_to_screen(next_screen)
            -- naughty.notify({
            --    title = "Moved to Screen",
            --    text = string.format("Swap failed → moved to screen %d", next_screen),
            --    timeout = 3
            -- })
         end
      else
         -- naughty.notify({
         --    title = "Client Swap",
         --    text = string.format("Moved: yes\nx: %d → %d\ny: %d → %d", x_before, x_after, y_before, y_after),
         --    timeout = 2
         -- })
      end
   end)
end

return move_client
