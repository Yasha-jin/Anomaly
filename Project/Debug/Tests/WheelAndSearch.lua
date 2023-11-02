local t = Def.ActorFrame {}

ReduceSound = function()
    SOUND:SetVolume(0.1)
end
BoostSound = function()
    SOUND:SetVolume(1)
end

t[#t + 1] = Def.Sprite {
    Texture = PathManager.DebugBackground,
    InitCommand = function(self)
        self:Center()
        self:zoomto(1920,1080)
    end,
    BeginCommand = function(self)
        InputManager.CreateInput("F7", InputManager.Press, ReduceSound)
        InputManager.CreateInput("F8", InputManager.Press, BoostSound)
    end
}

t[#t + 1] = LoadActor(PathManager.EtternaWheel)

return t