-- spawn.lua — shared spawn-next-to-focused helper
local awful = require("awful")

local M = {}

M.next_to_focused = {}

function M.spawn_next_to(focused_client, cmd)
	if focused_client then
		awful.spawn(cmd, {
			pid_callback = function(pid)
				M.next_to_focused[pid] = focused_client
			end,
		})
	else
		awful.spawn(cmd)
	end
end

return M
