local gears = require("gears")
local awful = require("awful")
local cairo = require("lgi").cairo

local M = {}

-- ===== color config =====
local H_RANGE = { 40, 360 }
local S_RANGE = { 0.45, 0.75 }
local L_RANGE = { 0.02, 0.1 }

-- ===== helpers =====
local function rand_between(a, b)
	return a + (b - a) * math.random()
end

local function hsl_to_rgb(h, s, l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local hp = (h % 360) / 60
	local x = c * (1 - math.abs((hp % 2) - 1))
	local r1, g1, b1
	if hp < 1 then
		r1, g1, b1 = c, x, 0
	elseif hp < 2 then
		r1, g1, b1 = x, c, 0
	elseif hp < 3 then
		r1, g1, b1 = 0, c, x
	elseif hp < 4 then
		r1, g1, b1 = 0, x, c
	elseif hp < 5 then
		r1, g1, b1 = x, 0, c
	else
		r1, g1, b1 = c, 0, x
	end
	local m = l - c / 2
	return r1 + m, g1 + m, b1 + m
end

local function rgb_to_hex(r, g, b)
	local function clamp01(v)
		return math.max(0, math.min(1, v))
	end
	local R = math.floor(255 * clamp01(r) + 0.5)
	local G = math.floor(255 * clamp01(g) + 0.5)
	local B = math.floor(255 * clamp01(b) + 0.5)
	return string.format("#%02X%02%02X", R, G, B)
end

local function random_color()
	local h = rand_between(H_RANGE[1], H_RANGE[2])
	local s = rand_between(S_RANGE[1], S_RANGE[2])
	local l = rand_between(L_RANGE[1], L_RANGE[2])
	local r, g, b = hsl_to_rgb(h, s, l)
	return string.format(
		"#%02X%02X%02X",
		math.floor(r * 255 + 0.5),
		math.floor(g * 255 + 0.5),
		math.floor(b * 255 + 0.5)
	)
end

-- one color per tag (session-only)
local function ensure_tag_color(t)
	if not t._wallpaper_color then
		t._wallpaper_color = random_color()
	end
	return t._wallpaper_color
end

local function paint_solid_surface(color, w, h)
	local surf = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
	local cr = cairo.Context(surf)
	cr:set_source(gears.color(color))
	cr:paint()
	return surf
end

local function apply_for_screen(s)
	if not s then
		return
	end
	local t = s.selected_tag or (s.tags and s.tags[1])
	local col = "#210000"
	if t then
		col = ensure_tag_color(t)
	end

	local g = s.geometry
	local surf = paint_solid_surface(col, g.width, g.height)

	-- Per-screen pixmap; does not affect other heads
	gears.wallpaper.maximized(surf, s, true)
end

-- ===== public =====
local seeded = false
function M.init()
	if not seeded then
		math.randomseed(os.time() + (awesome and awesome.pid or 0))
		seeded = true
	end

	-- Assign colors and paint when Awesome requests wallpaper for a screen
	screen.connect_signal("request::wallpaper", function(s)
		for _, t in ipairs(s.tags or {}) do
			ensure_tag_color(t)
		end
		apply_for_screen(s)
	end)

	-- Repaint ONLY the screen whose tag selection changed
	awful.screen.connect_for_each_screen(function(s)
		s:connect_signal("tag::history::update", function()
			apply_for_screen(s)
		end)
	end)

	-- Color newly created tags
	if not M._wrapped_add then
		local orig_add = awful.tag.add
		awful.tag.add = function(name, props)
			local t = orig_add(name, props)
			ensure_tag_color(t)
			return t
		end
		M._wrapped_add = true
	end
end

return M
