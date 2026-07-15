local gears                                     = require("gears")
local lain                                      = require("lain")
local awful                                     = require("awful")
local wibox                                     = require("wibox")
local dpi                                       = require("beautiful.xresources").apply_dpi
local markup                                    = lain.util.markup
local my_table                                  = awful.util.table or gears.table

local theme                                     = {}

local home                                      = os.getenv("HOME")
theme.dir                                       = home .. "/.config/awesome/theme"

-- Basic appearance
theme.font                                      = "FiraCode Nerd Font 10.5"
theme.taglist_font                              = "BaskervilleNeo Text 12.5"
theme.clock_font                                = "FiraCode Nerd Font 15.5"
theme.wallpaper                                 = theme.dir .. "/wall.png"

theme.fg_normal                                 = "#BBBBBB"
theme.fg_focus                                  = "#eed49f"
theme.bg_normal                                 = "#24273a"
theme.bg_focus                                  = "#1e1e2e"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#141414"
theme.border_focus                              = "#363a4f"
theme.useless_gap                               = 0

theme.tasklist_bg_focus                         = "#1e1e2e" -- background of active client
theme.tasklist_fg_focus                         = "#eed49f"
theme.tasklist_bg_normal                        = theme.bg_normal
theme.tasklist_fg_normal                        = theme.fg_normal
theme.tasklist_fg_minimize                      = "#6c6f85"
theme.tasklist_disable_icon                     = false
theme.tasklist_font                             = theme.font

-- Taglist
-- theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
-- theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.taglist_fg_focus                          = "#FFFFFF"
theme.taglist_bg_focus                          = "#1e1e2e"
theme.taglist_bg_normal                         = "#24273a"

-- Layouts
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"

-- Icons
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.vol                                       = theme.dir .. "/icons/vol.png"
theme.vol_low                                   = theme.dir .. "/icons/vol_low.png"
theme.vol_no                                    = theme.dir .. "/icons/vol_no.png"
theme.vol_mute                                  = theme.dir .. "/icons/vol_mute.png"
theme.play                                      = theme.dir .. "/icons/play.png"
theme.pause                                     = theme.dir .. "/icons/pause.png"

-- Titlebar
local tb                                        = theme.dir .. "/icons/titlebar/"
theme.titlebar_close_button_focus               = tb .. "close_focus.png"
theme.titlebar_close_button_normal              = tb .. "close_normal.png"
theme.titlebar_ontop_button_focus_active        = tb .. "ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = tb .. "ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = tb .. "ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = tb .. "ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = tb .. "sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = tb .. "sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = tb .. "sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = tb .. "sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = tb .. "floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = tb .. "floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = tb .. "floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = tb .. "floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = tb .. "maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = tb .. "maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = tb .. "maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = tb .. "maximized_normal_inactive.png"

-- Color aliases
local blue                                      = theme.fg_focus
local red                                       = "#EB8F8F"

-- Separators
local first                                     = wibox.widget.textbox(markup.font("Terminus 3", " "))
local spr                                       = wibox.widget.textbox(" ")
local small_spr                                 = wibox.widget.textbox(markup.font("Terminus 4", " "))
local bar_spr                                   = wibox.widget.textbox(
   markup.font("Terminus 3", " ") ..
   markup.fontfg(theme.font, "#777777", "|") ..
   markup.font("Terminus 5", " ")
)

-- Tag filtering: only show selected or non-empty
-- local orig_filter                               = awful.widget.taglist.filter.all
-- awful.widget.taglist.filter.all                 = function(t, args)
--    if t.selected or #t:clients() > 0 then
--       return orig_filter(t, args)
--    end
-- end
-- only selected
awful.widget.taglist.filter.selected_only       = function(t, args)
   if t.selected then
      return true
   end
end

-- Volume
-- MPD
local mpdicon                                   = wibox.widget.imagebox()
theme.mpd                                       = lain.widget.mpd({
   settings = function()
      if mpd_now.state == "play" then
         title  = mpd_now.title
         artist = " " ..
             mpd_now.artist .. markup("#777777", " <span font='Terminus 2'> </span>|<span font='Terminus 5'> </span>")
         mpdicon:set_image(theme.play)
      elseif mpd_now.state == "pause" then
         title  = "mpd "
         artist = "paused" .. markup("#777777", " |<span font='Terminus 5'> </span>")
         mpdicon:set_image(theme.pause)
      else
         title                  = ""
         artist                 = ""
         mpdicon._private.image = nil
         mpdicon:emit_signal("widget::redraw_needed")
         mpdicon:emit_signal("widget::layout_changed")
      end

      widget:set_markup(markup.font(theme.font, markup(blue, title) .. artist))
   end
})


-- ALSA volume bar
local volicon = wibox.widget.imagebox(theme.vol)
theme.volume = lain.widget.alsabar {
   width = dpi(59), border_width = 0, ticks = true, ticks_size = dpi(6),
   notification_preset = { font = theme.font },
   --togglechannel = "IEC958,3",
   settings = function()
      if volume_now.status == "off" then
         volicon:set_image(theme.vol_mute)
      elseif volume_now.level == 0 then
         volicon:set_image(theme.vol_no)
      elseif volume_now.level <= 50 then
         volicon:set_image(theme.vol_low)
      else
         volicon:set_image(theme.vol)
      end
   end,
   colors = {
      background = theme.bg_normal,
      mute       = red,
      unmute     = theme.fg_normal
   }
}
theme.volume.tooltip.wibox.fg = theme.fg_focus
theme.volume.bar:buttons(my_table.join(
   awful.button({}, 1, function()
      awful.spawn(string.format("%s -e alsamixer", awful.util.terminal))
   end),
   awful.button({}, 2, function()
      os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
      theme.volume.update()
   end),
   awful.button({}, 3, function()
      os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
      theme.volume.update()
   end),
   awful.button({}, 4, function()
      os.execute(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
      theme.volume.update()
   end),
   awful.button({}, 5, function()
      os.execute(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
      theme.volume.update()
   end)
))
local volumebg = wibox.container.background(theme.volume.bar, "#474747", gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, dpi(2), dpi(7), dpi(4), dpi(4))




-- Clock with calendar
local mytextclock = wibox.widget.textclock()
mytextclock.format = string.format("<span font='%s'>%%H:%%M</span>", theme.clock_font)

theme.cal = lain.widget.cal({
   attach_to = { mytextclock },
   notification_preset = {
      font = theme.clock_font,
      fg   = theme.fg_normal,
      bg   = theme.bg_normal
   }
})
-- Wibar setup
function theme.at_screen_connect(s)
   s.quake = lain.util.quake({ app = awful.util.terminal })

   gears.wallpaper.set("#220000", s)

   awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

   s.mypromptbox = awful.widget.prompt()
   s.mylayoutbox = awful.widget.layoutbox(s)
   s.mylayoutbox:buttons(my_table.join(
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(1) end),
      awful.button({}, 5, function() awful.layout.inc(-1) end)
   ))

   s.mytasklist = awful.widget.tasklist {
      screen          = s,
      filter          = awful.widget.tasklist.filter.currenttags,
      buttons         = awful.util.tasklist_buttons,
      layout          = {
         layout  = wibox.layout.fixed.horizontal,
         spacing = dpi(4),
      },
      widget_template = {
         {
            {
               {
                  {
                     id            = 'icon_role',
                     widget        = wibox.widget.imagebox,
                     resize        = true,
                     forced_height = dpi(12),
                     forced_width  = dpi(12),
                  },
                  widget = wibox.container.place,
                  valign = "center",
               },
               {
                  id     = 'text_role',
                  widget = wibox.widget.textbox,
               },
               layout  = wibox.layout.fixed.horizontal,
               spacing = dpi(4),
            },
            left   = dpi(6),
            right  = dpi(6),
            widget = wibox.container.margin,
         },
         id     = 'background_role',
         widget = wibox.container.background,
      },

      -- 👇 Add these two callbacks
      update_callback = function(self, c)
         local bg = self:get_children_by_id('background_role')[1]
         if c.minimized then
            bg.bg = beautiful.tasklist_bg_minimize or "#444444"
            bg.fg = beautiful.tasklist_fg_minimize or "#FF0000"
         elseif c == client.focus then
            bg.bg = beautiful.tasklist_bg_focus
            bg.fg = beautiful.tasklist_fg_focus
         elseif c.urgent then
            bg.bg = beautiful.tasklist_bg_urgent
            bg.fg = beautiful.tasklist_fg_urgent
         else
            bg.bg = beautiful.tasklist_bg_normal
            bg.fg = beautiful.tasklist_fg_normal
         end
      end,
   }

   client.connect_signal("property::minimized", function(c)
      if c.screen and c.screen.mytasklist then
         c.screen.mytasklist:emit_signal("widget::redraw_needed")
      end
   end)

   s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

   s.mywibox = awful.wibar({
      position = "bottom",
      screen   = s,
      height   = dpi(16),
      bg       = theme.bg_normal,
      fg       = theme.fg_normal
   })

   s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
         layout = wibox.layout.fixed.horizontal,
         small_spr,
         s.mylayoutbox,
         first,
         s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      {             -- Right widgets
         layout = wibox.layout.fixed.horizontal,
         small_spr,
         mpdicon,
         theme.mpd.widget,
         bar_spr,
         s.mytaglist, -- <== moved here
         bar_spr,
         volicon,
         volumewidget,
         bar_spr,
         wibox.widget.systray(),
         bar_spr,
         mytextclock,
      }
   }
end

return theme
