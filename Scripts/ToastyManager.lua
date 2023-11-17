--- Function related to toasties.
-- For everything related to toasties, may also contain override from _fallback.
-- @module ToastyManager
ToastyManager = {}

ToastyManager.Toasty = "default"
ToastyManager.LastToasty = "default"
ToastyManager.IsThemeToasty = true

ToastyManager.ImageExtensions = {"png", "jpg", "jpeg"}
ToastyManager.AudioExtensions = {"wav", "mp3", "ogg", "mp4"}

-- Override _fallback to use custom lua file added by toasties.
function getToastyAssetPath(type)
    if ToastyManager.IsThemeToasty then
        if type == "sound" then
            for i=1, #ToastyManager.AudioExtensions do
                local file = PathManager.DebugToasties .. ToastyManager.Toasty .. "/" .. ToastyManager.Toasty .. "." .. ToastyManager.AudioExtensions[i]
                if FILEMAN:DoesFileExist(file) then
                    return file
                end
            end
            return PathManager.DebugToasties .. ToastyManager.Toasty .. "/"
        elseif type == "image" then
            for i=1, #ToastyManager.ImageExtensions do
                local file = PathManager.DebugToasties .. ToastyManager.Toasty .. "/" .. ToastyManager.Toasty .. "." .. ToastyManager.ImageExtensions[i]
                if FILEMAN:DoesFileExist(file) then
                    return file
                end
            end
            return PathManager.DebugToasties .. ToastyManager.Toasty .. "/"
        end
    end

    local path = "/Assets/Toasties/" .. ToastyManager.Toasty .. "/"
	local files = FILEMAN:GetDirListing(path)
	if type == "sound" then
		for i=1, #files do
			local status = isAudio(files[i], ToastyManager.AudioExtensions)
			if status then
				return path .. "/" .. files[i]
			end
		end
        return PathManager.EmptyAudio
	end
	if type == "image" then
		for i=1, #files do
			local status = isImage(files[i], ToastyManager.ImageExtensions)
			if status then
				return path .. "/" .. files[i]
			end
		end
        return PathManager.EmptyImage
	end
	return false
end