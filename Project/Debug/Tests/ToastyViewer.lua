local t = Def.ActorFrame {}
local ToastiesActors = Def.ActorFrame {}
local ref = {}

local Toasties = {}
local DebugToasties = FILEMAN:GetDirListing(PathManager.DebugToasties, true, true)
local UserToasties = FILEMAN:GetDirListing("/Assets/Toasties/", true, true)
for i = 1, #DebugToasties do
    Toasties[#Toasties + 1] = DebugToasties[i]
end
for i = 1, #UserToasties do
    Toasties[#Toasties + 1] = UserToasties[i]
end
for i = 1, #Toasties do
    -- not sure if that match work on other OS than Windows
    Toasties[i] = Toasties[i]:match("^.+/(.+)$")
end

local current_wheel_index = 1
for i = 1, #Toasties do
    if Toasties[i] == LastToasty then
        current_wheel_index = i
    end
end
local visibleToasties = 5

IncreaseWheelIndex = function()
    current_wheel_index = Math.wrap(current_wheel_index, #Toasties) + 1
    UpdateWheel()
end

DecreaseWheelIndex = function()
    current_wheel_index = Math.wrap(current_wheel_index - 2, #Toasties) + 1
    UpdateWheel()
end

UpdateWheel = function()
    for i = 1, visibleToasties do
        local relative_index = (math.ceil(visibleToasties / 2) * -1) + (i - 1)
        local toasty = Toasties[Math.wrap(current_wheel_index + relative_index, #Toasties) + 1]
        ref.Menu:GetChild("Toasty" .. i):settext(toasty)
    end
    for i = 1, #ToastiesActors do
        if ToastiesActors[i]:GetName() ~= Toasties[current_wheel_index] .. i then
            ToastiesActors[i]:finishtweening()
            ToastiesActors[i]:visible(false)
        else
            LastToasty = Toasties[current_wheel_index]
            ToastiesActors[i]:finishtweening()
            ToastiesActors[i]:visible(true)
        end
    end
    SOUND:StopMusic()
end

ResetToasty = function(self, index)
    DebugToasty = Toasties[index]
    IsThemeToasty = true
    if index > #DebugToasties then
        IsThemeToasty = false
    end
    local child = self:GetChildren()
    for _, k in pairs(child) do
        for j, val in pairs(k) do
            val:diffusealpha(0)
            if j == 1 then
                val:Load(getToastyAssetPath("image"))
            elseif j == 2 then
                val:load(getToastyAssetPath("sound"))
            end
        end
    end
end

-- Menu/Information actor
local Menu = Def.ActorFrame {
    InitCommand = function(self)
        ref.Menu = self
    end,
    BeginCommand = function(self)
        InputManager.CreateInput("v",
            InputManager.Press,
            self.playcommand,
            {self, "Invisible"})
        
        InputManager.CreateInput("up",
            InputManager.Press,
            DecreaseWheelIndex)
        
        InputManager.CreateInput("down",
            InputManager.Press,
            IncreaseWheelIndex)
        
        UpdateWheel()
    end,
    InvisibleCommand = function(self)
        self:visible(not self:GetVisible())
    end
}

for i = 1, visibleToasties do
    Menu[#Menu + 1] = LoadFont("Common Large") .. {
        Name = "Toasty" .. i,
        InitCommand = function(self)
            self:x(1920.0 / 16)
            self:halign(0)
            if i == 3 then
                self:zoom(1.5)
            else
                self:zoom(1.2)
            end
            self:y(1080.0 / 2)
            self:addy(-120 + (60 * (i - 1)))
            self:settext("Toasty" .. i)
        end
    }
end

t[#t + 1] = Menu

for i = 1, #Toasties do
    DebugToasty = Toasties[i]
    local path = PathManager.DebugToasties
    if i > #DebugToasties then
        IsThemeToasty = false
        path = "/Assets/Toasties/"
    end
    -- look for a custom lua file and if there is one load it instead
    if FILEMAN:DoesFileExist(path .. DebugToasty .. "/default.lua") then
        t[#t + 1] = LoadActor(path .. DebugToasty .. "/default") .. {
            Name = DebugToasty .. i,
            InitCommand = function(self)
                ToastiesActors[#ToastiesActors + 1] = self
            end,
            BeginCommand = function(self)
                InputManager.CreateInput("space",
                    InputManager.Press,
                    self.playcommand,
                    {self, "PreTransition"})
                ResetToasty(self, i)
            end,
            PreTransitionCommand = function(self)
                if self:GetVisible() then
                    self:finishtweening()
                    self:playcommand("StartTransitioning")
                end
            end
        }
    else
        t[#t + 1] = Def.ActorFrame {
            Name = DebugToasty .. i,
            InitCommand = function(self)
                ToastiesActors[#ToastiesActors + 1] = self
            end,
            BeginCommand = function(self)
                InputManager.CreateInput("space",
                    InputManager.Press,
                    self.playcommand,
                    {self, "PreTransition"})
                ResetToasty(self, i)
            end,
            PreTransitionCommand = function(self)
                if self:GetVisible() then
                    self:finishtweening()
                    self:playcommand("StartTransitioning")
                end
            end,
            Def.Sprite {
                InitCommand = function(self)
                    self:xy(SCREEN_WIDTH + 100, SCREEN_CENTER_Y)
                    self:Load(getToastyAssetPath("image"))
                end,
                StartTransitioningCommand = function(self)
                    self:diffusealpha(1):decelerate(0.25):x(SCREEN_WIDTH - 100):sleep(1.75):accelerate(0.5):x(SCREEN_WIDTH + 100):linear(0):diffusealpha(0)
                end
            },
            Def.Sound {
                InitCommand = function(self)
                    self:load(getToastyAssetPath("sound"))
                end,
                StartTransitioningCommand = function(self)
                    self:play()
                end
            }
        }
    end
end

return t