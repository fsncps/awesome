local awful = require("awful")
local gears = require("gears")
local tag = require("awful.tag")
local naughty = require("naughty")

local M = {}

function M.resize_tile_vertical(delta)
   local c = client.focus
   if not c then return end

   local t = c.first_tag
   if not t then return end

   local layout = awful.layout.get(t.screen)
   if layout.name ~= "tile" then
      naughty.notify({ title = "Not using tile layout", text = layout.name })
      return
   end

   local cls = awful.client.tiled(t.screen)
   local idx
   for i, cl in ipairs(cls) do
      if cl == c then
         idx = i
         break
      end
   end
   if not idx then return end

   local nmaster = t.master_count or 1
   if idx <= nmaster then return end  -- skip master

   -- Column index (default 1 for single-column slave area)
   local col = 1
   local column_data = tag.getdata(t).windowfact
   column_data[col] = column_data[col] or {}

   -- Rebase index to current column
   local slave_idx = idx - nmaster

   local current = column_data[col][slave_idx] or 1
   local neighbor_idx = column_data[col][slave_idx + 1] and slave_idx + 1
       or column_data[col][slave_idx - 1] and slave_idx - 1

   if not neighbor_idx then
      naughty.notify({ title = "Resize failed", text = "No neighbor found" })
      return
   end

   local neighbor = column_data[col][neighbor_idx] or 1
   local step = delta / 100

   current = current + step
   neighbor = math.max(0.1, neighbor - step)

   column_data[col][slave_idx] = current
   column_data[col][neighbor_idx] = neighbor

   awful.layout.arrange(t.screen)
end

return M

