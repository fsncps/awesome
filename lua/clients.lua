-- clients.lua
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local spawn = require("spawn")

local mytable = awful.util.table or gears.table

return function(opts)
	local clientkeys = opts.clientkeys
	local clientbuttons = opts.clientbuttons
	local vi_focus = opts.vi_focus or false

	-- Rules
	awful.rules.rules = {
		{
			rule = { class = "spectacle" },
			properties = { floating = true, ontop = true },
			callback = function(c)
				awful.placement.centered(c, nil)
			end,
		},

		-- First wezterm: screen 1
		{ rule = { class = "wezterm-main" }, properties = { screen = 2, fullscreen = true } },
		{ rule = { class = "wezterm-second" }, properties = { screen = 1, fullscreen = true } },

		-- Librewolf and Dolphin tiled on screen 3 (1080p)
		{
			rule = { class = "librewolf" },
			properties = { screen = 3, tag = "apps" },
		},
		{
			rule = { class = "dolphin" },
			properties = { screen = 3, tag = "apps" },
		},

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
				size_hints_honor = false,
			},
		},
		{
			rule_any = {
				instance = { "DTA", "copyq", "pinentry" },
				class = {
					"Arandr",
					"Blueman-manager",
					"Gpick",
					"Kruler",
					"MessageWin",
					"Sxiv",
					"Tor Browser",
					"Wpa_gui",
					"veromix",
					"xtightvncviewer",
				},
				name = { "Event Tester" },
				role = {
					"AlarmWindow",
					"ConfigManager",
					"pop-up",
				},
			},
			properties = { floating = true },
		},
		{
			rule_any = { type = { "normal", "dialog" } },
			properties = { titlebars_enabled = true },
		},
	}

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
		awful.titlebar(c, { size = 32 }):setup({
			{ awful.titlebar.widget.iconwidget(c), buttons = buttons, layout = wibox.layout.fixed.horizontal },
			{
				{ align = "center", widget = awful.titlebar.widget.titlewidget(c) },
				buttons = buttons,
				layout = wibox.layout.flex.horizontal,
			},
			{
				awful.titlebar.widget.floatingbutton(c),
				awful.titlebar.widget.maximizedbutton(c),
				awful.titlebar.widget.stickybutton(c),
				awful.titlebar.widget.ontopbutton(c),
				awful.titlebar.widget.closebutton(c),
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		})
	end)
	-- Helper: decide when to show titlebar / border
	local function _should_show_titlebar(c)
		-- Show titlebar if any of these are true:
		return c.maximized or c.floating or c.sticky or c.ontop
	end

	local function _apply_titlebar_and_border(c)
		-- Fullscreen always hides titlebar & borders
		if c.fullscreen then
			awful.titlebar.hide(c)
			c.border_width = 0
			return
		end

		if _should_show_titlebar(c) then
			awful.titlebar.show(c)
			c.border_width = beautiful.border_width or 0
		else
			awful.titlebar.hide(c)
			-- border_width left to screen.lua's arrange handler (count-based)
		end
	end
	-- On new clients, apply our policy
	client.connect_signal("manage", function(c)
		if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_offscreen(c)
		end

		local pid = c.pid
		if pid and spawn.next_to_focused[pid] then
			local ref_client = spawn.next_to_focused[pid]
			if ref_client.valid and c.screen == ref_client.screen then
				c:move_to_tag(ref_client.first_tag)
				c:swap(ref_client)
			end
			spawn.next_to_focused[pid] = nil
		end

		_apply_titlebar_and_border(c)
	end)

	-- Whenever these properties change, re-apply our policy
	for _, prop in ipairs({ "floating", "maximized", "sticky", "ontop", "fullscreen" }) do
		client.connect_signal("property::" .. prop, _apply_titlebar_and_border)
	end

	client.connect_signal("mouse::enter", function(c)
		c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
	end)

	client.connect_signal("focus", function(c)
		c.border_color = beautiful.border_focus
	end)
	client.connect_signal("unfocus", function(c)
		c.border_color = beautiful.border_normal
	end)

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
