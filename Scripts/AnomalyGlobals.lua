--- Unclassified globals
-- Various variables/functions with no specific, to override _fallback functions,
-- comptability reason, such as other theme specific function, or Anomaly-Only stuffs.
-- @module AnomalyGlobals

-- Override to use custom lua file added by toasties.
-- todo: Add extension support.
Toasty = "default"
LastToasty = "default"
IsThemeToasty = true
getToastyAssetPath = function(type)
    if IsThemeToasty then
        if type == "sound" then
            return PathManager.DebugToasties .. Toasty .. "/" .. Toasty .. ".ogg"
        elseif type == "image" then
            return PathManager.DebugToasties .. Toasty .. "/" .. Toasty .. ".png"
        end
    end

    if type == "sound" then
        return "/Assets/Toasties/" .. Toasty .. "/" .. Toasty .. ".ogg"
    elseif type == "image" then
        return "/Assets/Toasties/" .. Toasty .. "/" .. Toasty .. ".png"
    end

    return
end