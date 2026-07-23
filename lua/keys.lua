-- {{{ Key bindings
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain = require("lain")
local move = require("move_client")
local resize_tile = require("resize_tile")
local spawn = require("spawn")
local config = require("config")
local modkey = config.modkey
local altkey = config.altkey
local terminal = config.terminal
local browser = config.browser
local vi_focus = config.vi_focus
local scrlocker = "xlock" -- or your actual locker
local mytable = awful.util.table or gears.table
local singleton = require("singleton_tag")
local tags = singleton.tags

globalkeys = mytable.join(
  -- Destroy all notifications
  awful.key({ "Control" }, "space", function()
    naughty.destroy_all_notifications()
  end, { description = "destroy all notifications", group = "hotkeys" }),
  -- Take a screenshot
  awful.key({}, "Print", function()
    awful.spawn("spectacle")
  end, { description = "take screenshot", group = "hotkeys" }),

  -- Suspend
  awful.key({ modkey }, "z", function()
    awful.spawn.with_shell("loginctl suspend")
  end, { description = "suspend system", group = "hotkeys" }),

  -- Show help
  awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

  -- Tag browsing
  awful.key({ modkey }, "Tab", awful.tag.viewnext, { description = "view next", group = "tag" }),
  awful.key({ modkey, "Shift" }, "Tab", awful.tag.viewprev, { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

  -- Default client focus
  awful.key({ altkey }, "Tab", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ altkey, "Shift" }, "Tab", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),

  -- By-direction client focus
  awful.key({ modkey }, "Down", function()
    awful.client.focus.global_bydirection("down")
    if client.focus then
      client.focus:raise()
    end
  end, { description = "focus down", group = "client" }),
  awful.key({ modkey }, "Up", function()
    awful.client.focus.global_bydirection("up")
    if client.focus then
      client.focus:raise()
    end
  end, { description = "focus up", group = "client" }),
  awful.key({ modkey }, "Left", function()
    awful.client.focus.global_bydirection("left")
    if client.focus then
      client.focus:raise()
    end
  end, { description = "focus left", group = "client" }),
  awful.key({ modkey }, "Right", function()
    awful.client.focus.global_bydirection("right")
    if client.focus then
      client.focus:raise()
    end
  end, { description = "focus right", group = "client" }),

  -- Menu
  awful.key({ modkey }, "w", function()
    awful.util.mymainmenu:show()
  end, { description = "show main menu", group = "awesome" }),

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

  -- Show/hide wibox
  awful.key({ modkey }, "b", function()
    for s in screen do
      s.mywibox.visible = not s.mywibox.visible
      if s.mybottomwibox then
        s.mybottomwibox.visible = not s.mybottomwibox.visible
      end
    end
  end, { description = "toggle wibox", group = "awesome" }),

  -- move client between tags
  awful.key({ modkey, "Control" }, "Tab", function()
    local c = client.focus
    if not c then
      return
    end
    local tags = c.screen.tags
    local cur_idx = awful.tag.getidx()
    local next_idx = (cur_idx % #tags) + 1
    c:move_to_tag(tags[next_idx])
    tags[next_idx]:view_only()
  end, { description = "move client to next tag", group = "move client" }),
  awful.key({ modkey, "Shift", "Control" }, "Tab", function()
    local c = client.focus
    if not c then
      return
    end
    local tags = c.screen.tags
    local cur_idx = awful.tag.getidx()
    local prev_idx = (cur_idx - 2 + #tags) % #tags + 1
    c:move_to_tag(tags[prev_idx])
    tags[prev_idx]:view_only()
  end, { description = "move client to previous tag", group = "move client" }),

  --resize
  awful.key({ modkey, "Shift", "Control" }, "Right", function()
    local layout = awful.layout.get(mouse.screen)
    if layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
      awful.tag.incmwfact(0.05)
    end
  end, { description = "increase master width", group = "client" }),

  awful.key({ modkey, "Shift", "Control" }, "Left", function()
    local layout = awful.layout.get(mouse.screen)
    if layout == awful.layout.suit.tile or layout == awful.layout.suit.tile.left then
      awful.tag.incmwfact(-0.05)
    end
  end, { description = "decrease master width", group = "client" }),

  awful.key({ modkey, "Shift", "Control" }, "Down", function()
    local layout = awful.layout.get(mouse.screen)
    if layout == awful.layout.suit.tile.top then
      awful.tag.incmwfact(0.05)
    end
  end, { description = "increase master height", group = "client" }),

  awful.key({ modkey, "Shift", "Control" }, "Up", function()
    local layout = awful.layout.get(mouse.screen)
    if layout == awful.layout.suit.tile.top then
      awful.tag.incmwfact(-0.05)
    end
  end, { description = "decrease master height", group = "client" }),

  -- Dynamic tagging
  awful.key({ modkey, "Shift" }, "n", function()
    lain.util.add_tag()
  end, { description = "add new tag", group = "tag" }),
  awful.key({ modkey, "Shift" }, "r", function()
    lain.util.rename_tag()
  end, { description = "rename tag", group = "tag" }),
  awful.key({ modkey, "Shift" }, "d", function()
    lain.util.delete_tag()
  end, { description = "delete tag", group = "tag" }),
  awful.key({ modkey, "Shift" }, "Page_Up", function()
    lain.util.move_tag(-1)
  end, { description = "move tag to the left", group = "tag" }),
  awful.key({ modkey, "Shift" }, "Page_Down", function()
    lain.util.move_tag(1)
  end, { description = "move tag to the right", group = "tag" }),

  -- Standard program
  -- awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
  --    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

  awful.key({ modkey }, "space", function()
    awful.layout.inc(1)
  end, { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, { description = "select previous", group = "layout" }),

  awful.key({ modkey, "Control" }, "j", function()
    resize_tile.resize_tile_vertical(20)
  end, { description = "increase slave height", group = "layout" }),

  awful.key({ modkey, "Control" }, "k", function()
    resize_tile.resize_tile_vertical(-20)
  end, { description = "decrease slave height", group = "layout" }),

  -- Resize focused client (up/down)
  awful.key({ modkey, "Shift" }, "F4", function(c)
    if client.focus then
      client.focus:relative_move(0, 0, 0, 20) -- grow height
    end
  end, { description = "increase client height", group = "client" }),

  awful.key({ modkey, "Shift" }, "F5", function(c)
    if client.focus then
      client.focus:relative_move(0, 0, 0, -20) -- shrink height
    end
  end, { description = "decrease client height", group = "client" }),

  awful.key({ modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, { description = "restore minimized", group = "client" }),

  -- Widgets popups
  -- awful.key({ altkey, }, "c", function() if beautiful.cal then beautiful.cal.show(7) end end,
  --    { description = "show calendar", group = "widgets" }),
  -- awful.key({ altkey, }, "h", function() if beautiful.fs then beautiful.fs.show(7) end end,
  --    { description = "show filesystem", group = "widgets" }),
  -- awful.key({ altkey, }, "w", function() if beautiful.weather then beautiful.weather.show(7) end end,
  --    { description = "show weather", group = "widgets" }),

  awful.key({ modkey }, "F1", function()
    tags.music:activate()
  end, { description = "music workspace", group = "apps" }),
  awful.key({ modkey }, "F2", function()
    tags.files:activate()
  end, { description = "files workspace", group = "apps" }),
  awful.key({ modkey }, "F3", function()
    tags.main:activate()
  end, { description = "email workspace", group = "apps" }),
  awful.key({ modkey }, "F4", function()
    tags.messaging:activate()
  end, { description = "messaging workspace", group = "apps" }),

  -- ALSA volume control
  awful.key({ altkey }, "Up", function()
    os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
    beautiful.volume.update()
  end, { description = "volume up", group = "hotkeys" }),
  awful.key({ altkey }, "Down", function()
    os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
    beautiful.volume.update()
  end, { description = "volume down", group = "hotkeys" }),
  awful.key({ altkey }, "m", function()
    os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    beautiful.volume.update()
  end, { description = "toggle mute", group = "hotkeys" }),

  -- User programs
  awful.key({ modkey }, "q", function()
    awful.spawn(browser)
  end, { description = "run browser", group = "launcher" }),
  -- awful.key({ modkey }, "p", function() awful.spawn("rofi -show drun") end,
  --    { description = "run launcher", group = "launcher" }),
  awful.key({ modkey }, "p", function()
    awful.spawn("rofi -show drun -theme ~/.config/rofi/themes/awesome-dark.rasi")
  end, { description = "run launcher", group = "launcher" }),
  awful.key({ modkey }, "f", function()
    spawn.spawn_next_to(client.focus, "dolphin")
  end, { description = "open file manager next to current", group = "launcher" }),
  awful.key({ modkey }, "k", function()
    awful.spawn("kitty")
  end, { description = "open kitty terminal", group = "launcher" }),
  awful.key({ modkey }, "t", function()
    awful.spawn("wezterm cli spawn --new-window")
  end, { description = "new wezterm window", group = "launcher" }),

  -- Prompt
  awful.key({ modkey }, "r", function()
    awful.screen.focused().mypromptbox:run()
  end, { description = "run prompt", group = "launcher" }),

  awful.key({ modkey }, "x", function()
    awful.prompt.run({
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    })
  end, { description = "lua execute prompt", group = "awesome" }),

  -----screenshot
  awful.key({ "Control" }, "#107", function()
    awful.spawn.with_shell("maim -s | xclip -selection clipboard -t image/png")
  end, { description = "Region direct to xclip", group = "launcher" })

  --]]
)

clientkeys = mytable.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey, "Shift" }, "c", function(c)
    c:kill()
  end, { description = "close", group = "client" }),
  awful.key(
    { modkey, "Control" },
    "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),

  awful.key({ modkey }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, { description = "move to screen", group = "client" }),
  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle keep on top", group = "client" }),
  awful.key({ modkey }, "n", function(c)
    c.minimized = true
  end, { description = "minimize", group = "client" }),

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
  client = clientkeys,
  vi_focus = vi_focus,
}
