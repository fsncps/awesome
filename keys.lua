-- {{{ Key bindings
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain = require("lain")
local move = require("move_client")
local modkey = "Mod3"
local altkey = "Mod1"
local terminal = "wezterm"
local browser = "librewolf"
local scrlocker = "xlock" -- or your actual locker
local mytable = awful.util.table or gears.table

globalkeys = mytable.join(
-- Destroy all notifications
   awful.key({ "Control", }, "space", function() naughty.destroy_all_notifications() end,
      { description = "destroy all notifications", group = "hotkeys" }),
   -- Take a screenshot
   awful.key({}, "Print",
      function() awful.spawn("spectacle") end,
      { description = "take screenshot", group = "hotkeys" }
   ),


   -- X screen locker
   awful.key({ modkey }, "z",
      function() awful.spawn("loginctl suspend") end,
      { description = "suspend system", group = "hotkeys" }
   ),

   -- Show help
   awful.key({ modkey, }, "s", hotkeys_popup.show_help,
      { description = "show help", group = "awesome" }),



   -- Tag browsing
   awful.key({ modkey, }, "Page_Up", awful.tag.viewprev,
      { description = "view previous", group = "tag" }),
   awful.key({ modkey, }, "Page_Down", awful.tag.viewnext,
      { description = "view next", group = "tag" }),
   awful.key({ modkey, }, "Escape", awful.tag.history.restore,
      { description = "go back", group = "tag" }),

   -- -- Non-empty tag browsing
   -- awful.key({ altkey }, "Left", function() lain.util.tag_view_nonempty(-1) end,
   --    { description = "view  previous nonempty", group = "tag" }),
   -- awful.key({ altkey }, "Right", function() lain.util.tag_view_nonempty(1) end,
   --    { description = "view  previous nonempty", group = "tag" }),

   -- Default client focus
   awful.key({ altkey, }, "Tab",
      function()
         awful.client.focus.byidx(1)
      end,
      { description = "focus next by index", group = "client" }
   ),
   awful.key({ altkey, "Shift" }, "Tab",
      function()
         awful.client.focus.byidx(-1)
      end,
      { description = "focus previous by index", group = "client" }
   ),

   -- By-direction client focus
   awful.key({ modkey }, "Down",
      function()
         awful.client.focus.global_bydirection("down")
         if client.focus then client.focus:raise() end
      end,
      { description = "focus down", group = "client" }),
   awful.key({ modkey }, "Up",
      function()
         awful.client.focus.global_bydirection("up")
         if client.focus then client.focus:raise() end
      end,
      { description = "focus up", group = "client" }),
   awful.key({ modkey }, "Left",
      function()
         awful.client.focus.global_bydirection("left")
         if client.focus then client.focus:raise() end
      end,
      { description = "focus left", group = "client" }),
   awful.key({ modkey }, "Right",
      function()
         awful.client.focus.global_bydirection("right")
         if client.focus then client.focus:raise() end
      end,
      { description = "focus right", group = "client" }),

   -- Menu
   awful.key({ modkey, }, "w", function() awful.util.mymainmenu:show() end,
      { description = "show main menu", group = "awesome" }),

   -- -- Layout manipulation
   awful.key({ modkey, "Shift" }, "Down", function()
      move.move_client_bydirection("down")
   end, { description = "move client down", group = "client" }),

   awful.key({ modkey, "Shift" }, "Up", function()
      move.move_client_bydirection("up")
   end, { description = "move client up", group = "client" }),

   awful.key({ modkey, "Shift" }, "Left", function()
      move.move_client_bydirection("left")
   end, { description = "move client left", group = "client" }),

   awful.key({ modkey, "Shift" }, "Right", function()
      move.move_client_bydirection("right")
   end, { description = "move client right", group = "client" }),


   awful.key({ modkey }, "F8", function()
      move.show_client_position()
   end, { description = "show client x/y", group = "debug" }),

   -- Show/hide wibox
   awful.key({ modkey }, "b", function()
         for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
               s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
         end
      end,
      { description = "toggle wibox", group = "awesome" }),

   -- move client to next tag/screen
   awful.key({ modkey, "Shift" }, "Page_Down", function()
      local c = client.focus
      if not c then return end
      local tags = c.screen.tags
      local cur_idx = awful.tag.getidx()
      local next_idx = (cur_idx % #tags) + 1
      c:move_to_tag(tags[next_idx])
      tags[next_idx]:view_only()
   end, { description = "move client to next tag", group = "move client" }),
   awful.key({ modkey, "Shift" }, "Page_Up", function()
      local c = client.focus
      if not c then return end
      local tags = c.screen.tags
      local cur_idx = awful.tag.getidx()
      local prev_idx = (cur_idx - 2 + #tags) % #tags + 1
      c:move_to_tag(tags[prev_idx])
      tags[prev_idx]:view_only()
   end, { description = "move client to previous tag", group = "move client" }),
   -- awful.key({ modkey, "Control" }, "Left", function()
   --    local c = client.focus
   --    if not c then return end
   --    local next_screen = c.screen.index % screen.count() + 1
   --    c:move_to_screen(next_screen)
   -- end, { description = "move client to next screen", group = "move client" }),
   -- awful.key({ modkey, "Control" }, "Right", function()
   --    local c = client.focus
   --    if not c then return end
   --    local prev_screen = (c.screen.index - 2 + screen.count()) % screen.count() + 1
   --    c:move_to_screen(prev_screen)
   -- end, { description = "move client to previous screen", group = "move client" }),

   --resize
   awful.key({ modkey, "Shift", "Control" }, "Right",
      function()
         local layout = awful.layout.get(mouse.screen)
         if layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
            awful.tag.incmwfact(0.05)
         end
      end,
      { description = "increase master width", group = "client" }),

   awful.key({ modkey, "Shift", "Control" }, "Left",
      function()
         local layout = awful.layout.get(mouse.screen)
         if layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
            awful.tag.incmwfact(-0.05)
         end
      end,
      { description = "decrease master width", group = "client" }),

   awful.key({ modkey, "Shift", "Control" }, "Down",
      function()
         local layout = awful.layout.get(mouse.screen)
         if layout == awful.layout.suit.tile.top then
            awful.tag.incmwfact(0.05)
         end
      end,
      { description = "increase master height", group = "client" }),

   awful.key({ modkey, "Shift", "Control" }, "Up",
      function()
         local layout = awful.layout.get(mouse.screen)
         if layout == awful.layout.suit.tile.top then
            awful.tag.incmwfact(-0.05)
         end
      end,
      { description = "decrease master height", group = "client" }),


   -- On-the-fly useless gaps change
   -- awful.key({ altkey, "Control" }, "+", function() lain.util.useless_gaps_resize(1) end,
   --    { description = "increment useless gaps", group = "tag" }),
   -- awful.key({ altkey, "Control" }, "-", function() lain.util.useless_gaps_resize(-1) end,
   --    { description = "decrement useless gaps", group = "tag" }),

   -- Dynamic tagging
   awful.key({ modkey, "Shift" }, "n", function() lain.util.add_tag() end,
      { description = "add new tag", group = "tag" }),
   awful.key({ modkey, "Shift" }, "r", function() lain.util.rename_tag() end,
      { description = "rename tag", group = "tag" }),
   -- awful.key({ modkey, "Shift" }, "Left", function() lain.util.move_tag(-1) end,
   --    { description = "move tag to the left", group = "tag" }),
   -- awful.key({ modkey, "Shift" }, "Right", function() lain.util.move_tag(1) end,
   --    { description = "move tag to the right", group = "tag" }),
   awful.key({ modkey, "Shift" }, "d", function() lain.util.delete_tag() end,
      { description = "delete tag", group = "tag" }),

   -- Standard program
   -- awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
   --    { description = "open a terminal", group = "launcher" }),
   awful.key({ modkey, "Control" }, "r", awesome.restart,
      { description = "reload awesome", group = "awesome" }),
   -- awful.key({ modkey, "Shift" }, "q", awesome.quit,
   --    { description = "quit awesome", group = "awesome" }),
   -- awful.key({ modkey, altkey }, "l", function() awful.tag.incmwfact(0.05) end,
   --    { description = "increase master width factor", group = "layout" }),
   -- awful.key({ modkey, altkey }, "h", function() awful.tag.incmwfact(-0.05) end,
   --    { description = "decrease master width factor", group = "layout" }),
   -- awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
   --    { description = "increase the number of master clients", group = "layout" }),
   -- awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
   --    { description = "decrease the number of master clients", group = "layout" }),
   -- awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
   --    { description = "increase the number of columns", group = "layout" }),
   -- awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
   --    { description = "decrease the number of columns", group = "layout" }),
   -- awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
   --    { description = "select next", group = "layout" }),
   -- awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
   --    { description = "select previous", group = "layout" }),

   awful.key({ modkey, "Control" }, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
         c:emit_signal("request::activate", "key.unminimize", { raise = true })
      end
   end, { description = "restore minimized", group = "client" }),

   -- Dropdown application
   awful.key({ modkey, }, "z", function() awful.screen.focused().quake:toggle() end,
      { description = "dropdown application", group = "launcher" }),

   -- Widgets popups
   awful.key({ altkey, }, "c", function() if beautiful.cal then beautiful.cal.show(7) end end,
      { description = "show calendar", group = "widgets" }),
   awful.key({ altkey, }, "h", function() if beautiful.fs then beautiful.fs.show(7) end end,
      { description = "show filesystem", group = "widgets" }),
   awful.key({ altkey, }, "w", function() if beautiful.weather then beautiful.weather.show(7) end end,
      { description = "show weather", group = "widgets" }),



   -- ALSA volume control
   awful.key({ altkey }, "Up",
      function()
         os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
         beautiful.volume.update()
      end,
      { description = "volume up", group = "hotkeys" }),
   awful.key({ altkey }, "Down",
      function()
         os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
         beautiful.volume.update()
      end,
      { description = "volume down", group = "hotkeys" }),
   awful.key({ altkey }, "m",
      function()
         os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
         beautiful.volume.update()
      end,
      { description = "toggle mute", group = "hotkeys" }),


   -- User programs
   awful.key({ modkey }, "q", function() awful.spawn(browser) end,
      { description = "run browser", group = "launcher" }),
   -- awful.key({ modkey }, "p", function() awful.spawn("rofi -show drun") end,
   --    { description = "run launcher", group = "launcher" }),
   awful.key({ modkey }, "p", function()
         awful.spawn("rofi -show drun -theme ~/.config/rofi/themes/awesome-dark.rasi")
      end,
      { description = "run launcher", group = "launcher" }),
   awful.key({ modkey }, "f", function()
      local c = client.focus
      if c then
         awful.spawn("dolphin", {
            pid_callback = function(pid)
               spawn_next_to_focused[pid] = c
            end
         })
      else
         awful.spawn("dolphin")
      end
   end, { description = "open file manager next to current", group = "launcher" }),
   awful.key({ modkey }, "k", function() awful.spawn("kitty") end,
      { description = "open kitty terminal", group = "launcher" }),
   awful.key({ modkey }, "t", function()
      awful.spawn("wezterm cli spawn --new-window")
   end, { description = "new wezterm window", group = "launcher" }),


   -- Prompt
   awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
      { description = "run prompt", group = "launcher" }),

   awful.key({ modkey }, "x",
      function()
         awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
         }
      end,
      { description = "lua execute prompt", group = "awesome" })
--]]
)

clientkeys = mytable.join(
   awful.key({ modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
   end, { description = "toggle fullscreen", group = "client" }),
   awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
      { description = "close", group = "client" }),
   awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
      { description = "toggle floating", group = "client" }),

   awful.key({ modkey }, "Return", function(c)
      c:swap(awful.client.getmaster())
   end, { description = "move to master", group = "client" }),
   awful.key({ modkey }, "o", function(c) c:move_to_screen() end,
      { description = "move to screen", group = "client" }),
   awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end,
      { description = "toggle keep on top", group = "client" }),
   awful.key({ modkey }, "n", function(c) c.minimized = true end,
      { description = "minimize", group = "client" }),

   awful.key({ modkey }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
   end, { description = "(un)maximize", group = "client" }),

   awful.key({ modkey, "Control" }, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
   end, { description = "(un)maximize vertically", group = "client" }),

   awful.key({ modkey, "Shift" }, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
   end, { description = "(un)maximize horizontally", group = "client" })
)




return {
   global = globalkeys,
   client = clientkeys
}
