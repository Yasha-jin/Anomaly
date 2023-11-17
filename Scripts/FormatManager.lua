--- File format.
-- For everything related to file format.
-- @module FormatManager

-- all the supported format in etterna
ImageFormat = {"png", "jpg", "jpeg", "gif", "bmp"}
AudioFormat = {"ogg", "wav", "mp3", "mp4"}
VideoFormat = {"avi", "f4v", "flv", "mkv", "mp4", "mpeg", "mpg", "mov", "ogv", "webm", "wmv"}

-- Second arg is optional, it will use those formats instead of global one if specified.
function isImage(filename, formats)
    formats = formats or {}
    if type(format) ~= "table" then
        formats = ImageFormat
    end
	local ext = GetFileExtension(filename)
	for i=1, #formats do
		if formats[i] == ext then return true end
	end
	return false
end

function isAudio(filename, formats)
    formats = formats or {}
    if type(format) ~= "table" then
        formats = AudioFormat
    end
	local ext = GetFileExtension(filename)
	for i=1, #formats do
		if formats[i] == ext then return true end
	end
	return false
end

function isVideo(filename, formats)
    formats = formats or {}
    if type(format) ~= "table" then
        formats = VideoFormat
    end
	local ext = GetFileExtension(filename)
	for i=1, #formats do
		if formats[i] == ext then return true end
	end
	return false
end

-- todo : add unit tests