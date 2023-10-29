local t = Def.ActorFrame {}

local FunctionTable = {}
FunctionTable.ReduceSound = function()
    SOUND:SetVolume(0.1)
end
FunctionTable.BoostSound = function()
    SOUND:SetVolume(1)
end

t[#t + 1] = Def.Sprite {
    Texture = PathManager.DebugBackground,
    InitCommand = function(self)
        self:Center()
        self:zoomto(1920,1080)
    end,
    BeginCommand = function(self)
        InputManager.CreateInput("F7", InputManager.Press, FunctionTable, "ReduceSound")
        InputManager.CreateInput("F8", InputManager.Press, FunctionTable, "BoostSound")
    end
}

t[#t + 1] = LoadActor(PathManager.EtternaWheel)

return t