--- Screen Manager or the metrics killer.
-- Me and the bois all hate the metrics.ini.
-- Simple and rely on reloading a single screen with different actor path to
-- simulate screen change, making the screen system purely in lua.
-- @module ScreenManager

-- Aliases for diverse screens.
ScreenManager = {
    Debug = "Debug/DebugScreen.lua"
}

ScreenManager.InitialScreen = ScreenManager.Debug

ScreenManager.PreviousScreen = ScreenManager.InitialScreen
ScreenManager.CurrentScreen = ScreenManager.InitialScreen
ScreenManager.ScreenParams = {}

-- the Screen path is always relative to the ScreenManager.lua file.
ScreenManager.NewScreen = function(NewScreen, ScreenParams)
    ScreenManager.ScreenParams = ScreenParams or {}
    ScreenManager.PreviousScreen = ScreenManager.CurrentScreen
    ScreenManager.CurrentScreen = NewScreen
    SCREENMAN:SetNewScreen("ScreenRedir")
end

