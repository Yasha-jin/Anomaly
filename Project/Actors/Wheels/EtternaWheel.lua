local current_opened_pack_index = 0
local current_wheel_index = 1
local Packs = {}
local wheel_information = {}
local button_amount = 10
local WheelActors = {}
local selected_btn_x = SCREEN_WIDTH
local pack_btn_x = SCREEN_WIDTH + 60
local song_btn_x = SCREEN_WIDTH + 100
local wheel_middle_index = 5
local FunctionTable = {}

FunctionTable.IncreaseWheelIndex = function()
    if current_opened_pack_index == 0 then
        current_wheel_index = Math.wrap(current_wheel_index, #Packs) + 1
    else
        current_wheel_index = Math.wrap(current_wheel_index, #Packs + #Packs[current_opened_pack_index]["Songs"]) + 1
    end
    
    FunctionTable.UpdateWheel()
end

FunctionTable.DecreaseWheelIndex = function()
    if current_opened_pack_index == 0 then
        current_wheel_index = Math.wrap(current_wheel_index - 2, #Packs) + 1
    else
        current_wheel_index = Math.wrap(current_wheel_index - 2, #Packs + #Packs[current_opened_pack_index]["Songs"]) + 1
    end
    FunctionTable.UpdateWheel()
end

FunctionTable.SendMouseInputCommand = function()
    WheelActors[wheel_middle_index]:queuecommand("MouseInput")
end

local temp_pack = {}

for pack_index, pack in ipairs(SONGMAN:GetSongGroupNames()) do
    table.insert(temp_pack, pack)
end

table.sort(temp_pack, SortManager.AlphaSort)

for pack_index, pack in ipairs(temp_pack) do
    table.insert(Packs, {Name = pack, Songs = {}})

    local temp_song = {}
    for song_index, song in ipairs(SONGMAN:GetSongsInGroup(pack)) do
        table.insert(temp_song, {Song = song, Name = song:GetDisplayMainTitle()})
    end

    table.sort(temp_song, SortManager.AlphaSort)

    for song_index, song in ipairs(temp_song) do
        table.insert(Packs[pack_index]["Songs"], {Song = song.Song, Name = song.Name, Difficulties = {}})

        -- gotta sort one day, probably sort by rating
        -- for difficulty_index, difficulty in ipairs(song:GetAllSteps()) do
        --     table.insert(Packs[pack_index]["Songs"][song_index]["Difficulties"], {Difficulty = difficulty:GetDifficulty()})
        -- end
    end
end

local t = Def.ActorFrame {
    BeginCommand = function(self)
        -- wheel input
        InputManager.CreateInput("mousewheel down", InputManager.Press, FunctionTable, "IncreaseWheelIndex")
        InputManager.CreateInput("mousewheel up", InputManager.Press, FunctionTable, "DecreaseWheelIndex")
        
        -- keyboard input
        InputManager.CreateInput("right", InputManager.Press, FunctionTable, "IncreaseWheelIndex")
        InputManager.CreateInput("right", InputManager.Repeat, FunctionTable, "IncreaseWheelIndex")
        InputManager.CreateInput("left", InputManager.Press, FunctionTable, "DecreaseWheelIndex")
        InputManager.CreateInput("left", InputManager.Repeat, FunctionTable, "DecreaseWheelIndex")
        InputManager.CreateInput("space", InputManager.Press, FunctionTable, "SendMouseInputCommand")

        FunctionTable.UpdateWheel()
    end
}

for i = 1, button_amount do
    local btn
    t[#t + 1] = Def.ActorFrame{
        LoadActorWithParams(PathManager.Button, {
            x = 960, y = 120, halign = 1, valign = 0, texture = PathManager.DebugButton}) .. {
                InitCommand = function(self)
                    btn = self
                end
            },
        InitCommand = function(self)
            if i == 5 then
                self:x(selected_btn_x)
            else
                self:x(pack_btn_x)
            end
            self:y(0 + (108 * (i - 1)))
            WheelActors[#WheelActors + 1] = self
        end,
        LoadFont("Common Large") .. {
            Name = "Pack",
            InitCommand = function(self)
                local x = btn:GetTexture():GetImageWidth() * btn:GetZoomX()
                local y = btn:GetTexture():GetImageHeight() * btn:GetZoomY()
                self:x(-x + 32)
                self:halign(0)
                self:valign(0.5)
                self:zoom(1.6)
                self:y(y / 2)
                self:visible(false)
            end,
        },
        LoadFont("Common Large") .. {
            Name = "SongTitle",
            InitCommand = function(self)
                local x = btn:GetTexture():GetImageWidth() * btn:GetZoomX()
                local y = btn:GetTexture():GetImageHeight() * btn:GetZoomY()
                self:x(-x + 32)
                self:halign(0)
                self:valign(0)
                self:zoom(1.2)
                self:y(16)
                self:visible(false)
            end,
        },
        MouseInputCommand = function(self)
            local text = self:GetChild("Pack"):GetText()
            for index, pack in ipairs(Packs) do
                if pack.Name == text then
                    if current_opened_pack_index == index then
                        current_wheel_index = current_opened_pack_index
                        current_opened_pack_index = 0
                    else
                        current_opened_pack_index = index
                        current_wheel_index = current_opened_pack_index
                    end
                end
            end

            FunctionTable.UpdateWheel()
        end,
        MouseOverCommand = function(self)
            
        end,
        MouseOutCommand = function(self)
            
        end
    }
end

FunctionTable.UpdateWheel = function()
    local wheel_information = {}

    if current_opened_pack_index ~= 0 then
        local temp = {}
        for i = 1, current_opened_pack_index do
            table.insert(temp, {Type = "Pack", Name = Packs[i]["Name"]})
        end

        for i = 1, #Packs[current_opened_pack_index]["Songs"] do
            table.insert(temp, {Type = "Song", Name = Packs[current_opened_pack_index]["Songs"][i]["Name"]})
        end

        for i = 1 + current_opened_pack_index, #Packs do
            table.insert(temp, {Type = "Pack", Name = Packs[i]["Name"]})
        end

        for i = 1, button_amount do
            local index = Math.wrap(current_wheel_index - (wheel_middle_index + 1) + i, #temp) + 1
            table.insert(wheel_information, {Type = temp[index]["Type"], Name = temp[index]["Name"]})
        end
    else
        for i = 1, button_amount do
            local index = Math.wrap(current_wheel_index - (wheel_middle_index + 1) + i, #Packs) + 1
            table.insert(wheel_information, {Type = "Pack", Name = Packs[index]["Name"]})
        end
    end

    for i, btn in ipairs(WheelActors) do
        if wheel_information[i]["Type"] == "Pack" then
            btn:x(pack_btn_x)
            if current_opened_pack_index ~= 0 then
                if wheel_information[i]["Name"] == Packs[current_opened_pack_index]["Name"] then
                    btn:x(selected_btn_x)
                elseif i == wheel_middle_index then
                    btn:x(selected_btn_x)
                end
            elseif current_opened_pack_index == 0 and i == wheel_middle_index then
                btn:x(selected_btn_x)
            end
            btn:GetChild("Pack"):visible(true)
            btn:GetChild("Pack"):settext(wheel_information[i]["Name"])
            btn:GetChild("SongTitle"):visible(false)
        elseif wheel_information[i]["Type"] == "Song" then
            btn:x(song_btn_x)
            if i == wheel_middle_index then
                btn:x(pack_btn_x)
                FunctionTable.UpdateScreen()
            end
            btn:GetChild("Pack"):visible(false)
            btn:GetChild("SongTitle"):visible(true)
            btn:GetChild("SongTitle"):settext(wheel_information[i]["Name"])
        end
    end
end

FunctionTable.UpdateScreen = function()
    -- Trace("Selected Pack : " .. Packs[current_opened_pack_index]["Name"])
    -- Trace("Selected Song : " .. Packs[current_opened_pack_index]["Songs"][current_wheel_index - current_opened_pack_index]["Name"])

    local song = Packs[current_opened_pack_index]["Songs"][current_wheel_index - current_opened_pack_index]["Song"]

    local samplelength = song:GetSampleLength()

    if samplelength > song:GetLastSecond() then
        samplelength = song:GetLastSecond()
    end

    SOUND:PlayMusicPart(
        song:GetMusicPath(),
        song:GetSampleStart(),
        samplelength,
        0.0, -- doesn't seems to do anything
        1.0,
        true,
        false,
        false
    )
end

return t