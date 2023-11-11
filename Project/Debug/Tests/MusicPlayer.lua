local t = Def.ActorFrame {}

local textures = {
    Marker = PathManager.DebugSliderMarker,
    BG = PathManager.DebugSliderBG,
    Fill = PathManager.DebugSliderRange
}

local songs = SONGMAN:GetAllSongs()
local songsList = {}
local songsListIndex = 0
local currentsong = nil
local delay = 0.016
local index = 0
local maxindex = 0
local IsPaused = false
local IsMoving = false

PlaySong = function(self, params)
    if #songs == 0 then ms.ok("No songs to play") return end
    IsPaused = false
    self:GetParent():GetChild("Pause"):Load(PathManager.DebugPause)
    self:stoptweening()

    local song
    local preview
    if params ~= nil then
        song = currentsong
        preview = params.start / 1000
    else
        song = songs[math.random(#songs)]
        while song == currentsong do
            song = songs[math.random(#songs)]
        end
        if songsList[songsListIndex + 1] == nil then
            songsList[#songsList + 1] = song
        end
        songsListIndex = songsListIndex + 1
        song = songsList[songsListIndex]
        currentsong = song
        preview = song:GetSampleStart()
    end

    local length = song:MusicLengthSeconds()
    -- clamp at 0 in case a chart has the preview set to negative. clamp 1ms before the end
    -- so the console doesn't throw an error.
    preview = clamp(preview, 0, length - 0.001)

    SOUND:StopMusic()
    SOUND:PlayMusicPart(
        song:GetMusicPath(),
        preview,
        length - preview,
        0.0,
        1.0,
        false,
        false,
        false
    )
    self:GetParent():GetChild("SongTitle"):settext(song:GetDisplayArtist() .. " - " .. song:GetDisplayMainTitle())
    index = math.ceil(preview * 1000)
    maxindex = math.ceil(length * 1000)
    
    self:playcommand("SetRange", {min = 0, max = maxindex})
    self:playcommand("SetIndex", {value = index})
    self:queuecommand("Update")
end

t[#t + 1] = LoadActorWithParams(PathManager.Slider, {
        Textures = textures,
        MarkerOffset = 20,
        Callback = function(self, params)
            if params.event == "Release" then
                PlaySong(self, {song = currentsong, start = params.value})
            elseif params.event == "Drag" then
                IsMoving = true
            else
                IsMoving = false
            end
        end}) .. {
    BeginCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 2)
        self:zoomto(2.0,0.5)
        
        -- delay is necessary otherwise it will not play the song
        SCREENMAN:GetTopScreen():setTimeout(function()
            PlaySong(self)
        end,
        0.1)
    end,
    UpdateCommand = function(self)
        if IsPaused == false and IsMoving == false then
            index = index + (delay * 1000)
            self:playcommand("SetIndex", {value = index})
            self:sleep(delay)
            if index < maxindex then
                self:queuecommand("Update")
            else
                PlaySong(self)
            end
        end
    end
}

t[#t + 1] = LoadFont("Common Large") .. {
    Name = "SongTitle",
    InitCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 2.5)
        self:zoom(1.5)
        self:settext("")
    end
}

t[#t + 1] = UIElements.SpriteButton(1, 1, PathManager.DebugPrevious) .. {
    Name = "Previous",
    InitCommand = function(self)
        self:x(1920.0 / 2 - 128)
        self:y(1080.0 / 1.5)
    end,
    MouseDownCommand = function(self, params)
        if params.event ~= "DeviceButton_left mouse button" then return end
        songsListIndex = clamp(songsListIndex - 2, 0, #songsList + 1)
        PlaySong(self:GetParent():GetChild("Slider"))
    end,
}

t[#t + 1] = UIElements.SpriteButton(1, 1, PathManager.DebugPause) .. {
    Name = "Pause",
    InitCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 1.5)
    end,
    MouseDownCommand = function(self, params)
        if params.event ~= "DeviceButton_left mouse button" then return end
        if IsPaused then
            IsPaused = false
            self:Load(PathManager.DebugPause)
            PlaySong(self:GetParent():GetChild("Slider"), {song = currentsong, start = index})
        else
            IsPaused = true
            SOUND:StopMusic()
            self:Load(PathManager.DebugResume)
        end
    end,
}

t[#t + 1] = UIElements.SpriteButton(1, 1, PathManager.DebugNext) .. {
    Name = "Next",
    InitCommand = function(self)
        self:x(1920.0 / 2 + 128)
        self:y(1080.0 / 1.5)
    end,
    MouseDownCommand = function(self, params)
        if params.event ~= "DeviceButton_left mouse button" then return end
        PlaySong(self:GetParent():GetChild("Slider"))
    end,
}

return t