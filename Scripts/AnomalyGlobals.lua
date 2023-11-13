--- Unclassified globals
-- Various variables/functions with no specific, to override _fallback functions,
-- or comptability reason, such as other theme specific function.
-- @module AnomalyGlobals

-- Override to use custom lua file added by toasties.
-- todo: Add extension support.
DebugToasty = "default"
LastToasty = "default"
IsThemeToasty = true
getToastyAssetPath = function(type)
    if IsThemeToasty then
        if type == "sound" then
            return PathManager.DebugToasties .. DebugToasty .. "/" .. DebugToasty .. ".ogg"
        elseif type == "image" then
            return PathManager.DebugToasties .. DebugToasty .. "/" .. DebugToasty .. ".png"
        end
    end

    if type == "sound" then
        return "/Assets/Toasties/" .. DebugToasty .. "/" .. DebugToasty .. ".ogg"
    elseif type == "image" then
        return "/Assets/Toasties/" .. DebugToasty .. "/" .. DebugToasty .. ".png"
    end

    return
end