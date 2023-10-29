local t = Def.ActorFrame {}
local FunctionTable = {}

local textures = {
    Marker = PathManager.DebugSliderMarker,
    BG = PathManager.DebugSliderBG,
    Fill = PathManager.DebugSliderRange
}

FunctionTable.Test = function(params)
    Trace(params.Action)
end

t[#t + 1] = LoadActorWithParams(PathManager.Slider, {
        Textures = textures,
        MarkerOffset = 20,
        Callback = FunctionTable.Test,
        MaxRange = 10}) .. {
    BeginCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 2)
        -- self:zoomto(0.5,0.2)
    end
}

return t