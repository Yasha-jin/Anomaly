local t = Def.ActorFrame {}

local textures = {
    Marker = PathManager.DebugSliderMarker,
    BG = PathManager.DebugSliderBG,
    Fill = PathManager.DebugSliderRange
}


t[#t + 1] = LoadActorWithParams(PathManager.SliderRange, {
        Textures = textures,
        MarkerOffset = 0,
        Callback = function(self, params)
            if params.event == "Release" then
                Trace("Min : " .. tostring(params.min) .. " | Max : " .. tostring(params.max))
            end
        end,
        MinRange = 100,
        MaxRange = 1000}) .. {
    BeginCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 2)
    end
}

return t