local t = Def.ActorFrame {}

local textures = {
    Marker = PathManager.DebugSliderMarker,
    BG = PathManager.DebugSliderBG,
    Fill = PathManager.DebugSliderRange
}

t[#t + 1] = LoadActorWithParams(PathManager.Slider, {
        Textures = textures,
        MarkerOffset = 20,
        Callback = function(self, params)
            if params.event == "Release" then
                Trace("Value : " .. tostring(params.value))
            end
        end,
        MaxRange = 10,
        InitRange = 5}) .. {
    BeginCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 2)
        -- self:zoomto(0.5,0.2)
    end
}

return t