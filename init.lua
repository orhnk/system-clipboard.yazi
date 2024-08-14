-- Meant to run at async context. (yazi copy-file)
-- REF: https://github.com/yazi-rs/plugins/blob/main/chmod.yazi/init.lua

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local get_file_path = ya.sync(function(file)
	return toString(file.url)
end)

local get_file_mimetype = ya.sync(function(file)
	return file:mime()
end)


return {
	entry = function()
		ya.manager_emit("escape", { visual = true })

		-- local files = selected_or_hovered()[1]
		local files = cx.active.current.hovered

		ya.dbg(files)
		-- ya.notify({ title = "XClip", content = table.concat(files, " "), level = "warn", timeout = 5 })
		-- ya.notify({ title = "XClip", content = files, level = "warn", timeout = 5 })
		ya.notify({ title = tostring(files.url), content = files:mime(), level = "info", timeout = 5 })

		-- if #files == 0 then
		-- 	return ya.notify({ title = "XClip", content = "No file selected", level = "warn", timeout = 5 })
		-- end

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
		ya.notify({ title = tostring(files.url), content = table.concat(xclip, " "), level = "info", timeout = 5 })

		-- ya.dbg({ status, err })

		-- if not status or not status.success then
		-- 	ya.notify({
		-- 		title = "XClip",
		-- 		content = string.format(
		-- 			"xclip with selected files failed, exit code %s",
		-- 			status and status.code or err
		-- 		),
		-- 		level = "error",
		-- 		timeout = 5,
		-- 	})
		-- end
	end,
}
