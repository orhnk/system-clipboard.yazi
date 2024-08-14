-- Meant to run at sync context. (yazi --sync simple-clipboard)

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
