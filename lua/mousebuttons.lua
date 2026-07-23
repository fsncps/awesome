-- mouse.lua — client + root mouse button definitions (pure module, no side effects)
local awful = require("awful")
local gears = require("gears")

local config = require("config")
local modkey = config.modkey
local mytable = awful.util.table or gears.table

local M = {}

-- Global mouse bindings (applied by rc.lua via root.buttons)
M.root_buttons = mytable.join(
	awful.button({}, 3, function()
		awful.util.mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
)

-- Client mouse bindings
M.clientbuttons = mytable.join(
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

return M
