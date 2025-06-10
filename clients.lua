-- clients.lua
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local mytable = awful.util.table or gears.table

return function(opts)
   local clientkeys = opts.clientkeys
   local clientbuttons = opts.clientbuttons
   local vi_focus = opts.vi_focus or false

   -- Rules
   awful.rules.rules = {
      {
         rule = {},
         properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
         }
      },
      {
         rule_any = {
            instance = { "DTA", "copyq", "pinentry" },
            class = {
               "Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin",
               "Sxiv", "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            name = { "Event Tester" },
            role = {
               "AlarmWindow", "ConfigManager", "pop-up"
            }
         },
         properties = { floating = true }
      },
      {
         rule_any = { type = { "normal", "dialog" } },
         properties = { titlebars_enabled = true }
      }
   }

   -- Signals
   client.connect_signal("manage", function(c)
      if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
         awful.placement.no_offscreen(c)
      end
   end)

   client.connect_signal("request::titlebars", function(c)
      if beautiful.titlebar_fun then
         beautiful.titlebar_fun(c)
         return
      end

      local buttons = mytable.join(
         awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
         end),
         awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
         end)
      )

      awful.titlebar(c, { size = 32 }):setup {
         { awful.titlebar.widget.iconwidget(c), buttons = buttons, layout = wibox.layout.fixed.horizontal },
         { { align = "center", widget = awful.titlebar.widget.titlewidget(c) },
            buttons = buttons, layout = wibox.layout.flex.horizontal },
         { awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal },
         layout = wibox.layout.align.horizontal
      }
   end)

   client.connect_signal("mouse::enter", function(c)
      c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
   end)

   client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
   client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

   local function backham()
      local s = awful.screen.focused()
      local c = awful.client.focus.history.get(s, 0)
      if c then
         client.focus = c
         c:raise()
      end
   end

   client.connect_signal("property::minimized", backham)
   client.connect_signal("unmanage", backham)
   tag.connect_signal("property::selected", backham)
end
