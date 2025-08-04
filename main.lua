-- Meant to run at async context. (yazi system-clipboard)

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

local function file_list_to_clipboard(urls, as_uri)
	-- Format the URLs for `text/uri-list` specification
	local function encode_uri(uri)
		return uri:gsub("([^%w%-%._~:/])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
	end

	local file_list_formatted = ""
	for _, path in ipairs(urls) do
		if as_uri then
			-- Each file path must be URI-encoded and prefixed with "file://"
			file_list_formatted = file_list_formatted .. "file://" .. encode_uri(path) .. "\r\n"
		else
			file_list_formatted = file_list_formatted .. path .. "\n"
		end
	end

	local status, err
	if as_uri then
		-- Run either `cb` or `wl-copy` to copy the file list to the clipboard
		local xdg_session_type = os.getenv("XDG_SESSION_TYPE") or 
			(os.getenv("WAYLAND_DISPLAY") and "wayland") or 
			(os.getenv("DISPLAY") and "x11")
		if xdg_session_type == "wayland" then
			-- We don't use `cb` here because of a critical bug as of v0.10.0, https://github.com/Slackadays/Clipboard/releases/tag/0.10.0.
			-- Cf. also https://github.com/Slackadays/Clipboard/issues/171.
			status, err = Command("wl-copy"):arg("--type"):arg("text/uri-list"):arg(file_list_formatted):spawn():wait()
		elseif xdg_session_type == "x11" then
			status, err = Command("cb"):arg("copy"):arg("--mime"):arg("text/uri-list"):arg(file_list_formatted):spawn():wait()
		else
			ya.notify({
				title = "System Clipboard",
				content = "`uri-list` not supported on your system",
				level = "error",
				timeout = 5,
			})
			return
		end
	else
		ya.clipboard(file_list_formatted)
		status = { success = true }
	end

	if status and status.success then
		ya.notify({
			title = "System Clipboard",
			content = "Successfully copied the file(s) to system clipboard",
			level = "info",
			timeout = 2,
		})
	end

	if not status or not status.success then
		ya.notify({
			title = "System Clipboard",
			content = string.format("Could not copy selected file(s) %s", status and status.code or err),
			level = "error",
			timeout = 5,
		})
	end
end

local function content_to_clipboard(urls)
	local content = ""
	for _, url in ipairs(urls) do
		local file = io.open(url, "r")
		if file then
			content = content .. file:read("*all") .. "\n"
			file:close()
		else
			return ya.notify({
				title = "System Clipboard",
				content = string.format("Could not read file '%s'", url),
				level = "error",
				timeout = 5,
			})
		end

	end
	ya.clipboard(content)
	ya.notify({
		title = "System Clipboard",
		content = "Content copied to clipboard",
		level = "info",
		timeout = 2,
	})
end

--- @since 0.3.0
return {
	entry = function(_, job)
		local action = job.args[1]
		if not action then
			action = "file-list"
		end

		-- Check if the action is valid.
		if action ~= "file-list" and action ~= "uri-list" and action ~= "content" then
			return ya.notify({
				title = "System Clipboard",
				content = string.format("Unknown action '%s'", action),
				level = "error",
				timeout = 5,
			})
		end

		ya.manager_emit("escape", { visual = true })

		local urls = selected_or_hovered()

		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end

		if action == "file-list" or action == "uri-list" then
			file_list_to_clipboard(urls, action == "uri-list")
		end
		if action == "content" then
			content_to_clipboard(urls)
		end
	end,
}

