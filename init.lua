-- Meant to run at sync context. (yazi --sync system-clipboard)
-- REF: https://github.com/yazi-rs/plugins/blob/main/chmod.yazi/init.lua

return {
	entry = function()
		ya.manager_emit("escape", { visual = true })

		local files = cx.active.current.hovered
		local xclip = {
			"xclip",
			"-selection",
			"clipboard",
			"-i",
			"-t",
			files:mime(),
			"<",
			tostring(files.url),
		}

		os.execute(table.concat(xclip, " "))
	end,
}
