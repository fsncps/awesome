local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

-- 📺 Explicitly get HDMI-0 screen
local function get_hdmi0_screen()
   for s in screen do
      if s.outputs and s.outputs["HDMI-0"] then
         return s
      end
   end
   return screen.primary
end

-- 📦 Create the text widget
local discordian_widget = wibox.widget {
   widget = wibox.widget.textbox,
   font = "FiraCode Nerd Font 12",
   markup = "<span foreground='#ffff99'>Loading Discordian prophecy...</span>",
   align = "left",
   valign = "top",
}

-- 🔁 Update function
local function update_discordian()
   awful.spawn.easy_async_with_shell(
      [[echo "$(ddate +"It's %{%A, the %e of %B%}, %Y YOLD. %N%nCelebrate %H")\n\n$(fortune)"]],
      function(stdout)
         discordian_widget.markup = "<span foreground='#ffff99'>" ..
             gears.string.xml_escape(stdout) .. "</span>"
      end
   )
end

-- 🔁 Initial + timer refresh
update_discordian()

gears.timer {
   timeout = 1800,  -- every 30 minutes
   autostart = true,
   callback = update_discordian
}

-- 🪟 Create top-left wibox on HDMI-0
local s = get_hdmi0_screen()

s.discordian_box = wibox({
   screen = s,
   x = 10,
   y = 10,
   width = 600,
   height = 200,
   bg = "#00000000",  -- needs compositor
   ontop = false,
   visible = true,
   type = "desktop",
})

s.discordian_box:setup {
   layout = wibox.layout.fixed.vertical,
   {
      widget = wibox.container.margin,
      margins = 10,
      discordian_widget,
   },
}
