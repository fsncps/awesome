local awful = require("awful")
local gears = require("gears")

local SingletonTag = {}
SingletonTag.__index = SingletonTag

function SingletonTag:new(name, layout, spawn_list)
	return setmetatable({
		name = name,
		layout = layout or awful.layout.suit.tile,
		spawn_list = spawn_list or {},
	}, self)
end

function SingletonTag:activate()
	local tag

	-- Search all screens for an existing tag with this name
	for s in screen do
		local existing = awful.tag.find_by_name(s, self.name)
		if existing and existing.valid then
			tag = existing
			break
		end
	end

	-- If not found, create it
	if not tag then
		local screen = awful.screen.focused()
		tag = awful.tag.add(self.name, {
			layout = self.layout,
			screen = screen,
			selected = true,
		})
		tag:view_only()
	else
		tag:view_only()
	end

	-- Spawn if the tag is empty
	if #tag:clients() == 0 then
		for _, cmd in ipairs(self.spawn_list) do
			awful.spawn(cmd)
		end
	end

	-- Focus master client if any
	gears.timer.delayed_call(function()
		local c = awful.client.getmaster()
		if c and c.valid then
			client.focus = c
			c:raise()
		end
	end)
end

-- Workspace registry
local tags = {
	--  Music
	music = SingletonTag:new(" ", awful.layout.suit.tile, {
		"librewolf --profile /home/fsncps/.librewolf-music --no-remote https://play.qobuz.com",
	}),

	--  Files
	files = SingletonTag:new(" ", awful.layout.suit.tile, {
		"wezterm cli spawn --new-window spf",
	}),

	-- 󱡯 Main (Email)
	main = SingletonTag:new("󰻧 ", awful.layout.suit.tile, {
		"thunderbird",
	}),

	-- 󰭹 Messaging
	messaging = SingletonTag:new(" ", awful.layout.suit.tile, {
		-- Define your messaging launcher here, e.g.:
		"wezterm cli spawn --new-window /usr/bin/signal-desktop",
		"Kotatogram",
	}),
}

return {
	SingletonTag = SingletonTag,
	tags = tags,
}
