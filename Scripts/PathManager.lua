--- Path Manager helper for convenience.
-- Include Base path, General path, Functions to get file from type and name.
-- Also include several files path for quick access convenience.
-- Mostly meant for Assets/Resources. Use as you see fit. 
-- @module PathManager
PathManager = {}

-- Base path of the currently loaded theme.
PathManager.BasePath = "/Themes/" .. THEME:GetCurThemeName() .. "/"
PathManager.ProjectPath = PathManager.BasePath .. "Project/"

--- ActorPath
-- Path to the Actor folder.
PathManager.ActorPath = PathManager.ProjectPath .. "Actors/"

-- Aliases for ActorType
PathManager.ActorType = {
    Control = "Controls",
    Wheel = "Wheels"
}

PathManager.ActorControlPath = PathManager.ActorPath .. PathManager.ActorType.Control .. "/"
PathManager.ActorWheelPath = PathManager.ActorPath .. PathManager.ActorType.Wheel .. "/"

PathManager.Button = PathManager.ActorControlPath .. "Button.lua"
PathManager.MultiSprite = PathManager.ActorControlPath .. "MultiSprite.lua"
PathManager.Slider = PathManager.ActorControlPath .. "Slider.lua"
PathManager.SliderRange = PathManager.ActorControlPath .. "SliderRange.lua"
PathManager.EtternaWheel = PathManager.ActorWheelPath .. "EtternaWheel.lua"

PathManager.GetActor = function(ActorType, ActorName)
    return PathManager.ActorPath .. ActorType .. "/" .. ActorName .. ".lua"
end

--- DebutAssetPath
-- Paths to assets inside the Debug Folder.
PathManager.DebugPath = PathManager.ProjectPath .. "Debug/"
PathManager.DebugAssetPath = PathManager.DebugPath .. "DebugAssets/"

-- Aliases for DebugAssetType
PathManager.DebugAssetType = {
    Graphics = "Graphics"
}

PathManager.DebugGraphic = PathManager.DebugAssetPath .. PathManager.DebugAssetType.Graphics .. "/"

PathManager.DebugMultiSprite = PathManager.DebugGraphic .. "MultiSprite/"
PathManager.DebugSpritesheet = PathManager.DebugGraphic .. "Spritesheet 7x28.png"
PathManager.DebugBackground = PathManager.DebugGraphic .. "menu-background.jpg"
PathManager.DebugButton = PathManager.DebugGraphic .. "menu-button-background.png"
PathManager.DebugSliderMarker = PathManager.DebugGraphic .. "Slider/Marker.png"
PathManager.DebugSliderBG = PathManager.DebugGraphic .. "Slider/BG.png"
PathManager.DebugSliderRange = PathManager.DebugGraphic .. "Slider/Range.png"
PathManager.DebugPause = PathManager.DebugGraphic .. "MusicPlayer/Pause.png"
PathManager.DebugResume = PathManager.DebugGraphic .. "MusicPlayer/Resume.png"
PathManager.DebugPrevious = PathManager.DebugGraphic .. "MusicPlayer/Previous.png"
PathManager.DebugNext = PathManager.DebugGraphic .. "MusicPlayer/Next.png"

PathManager.GetDebugAsset = function(DebugAssetType, DebugAssetName)
    return PathManager.DebugAssetPath .. DebugAssetType .. "/" .. DebugAssetName
end