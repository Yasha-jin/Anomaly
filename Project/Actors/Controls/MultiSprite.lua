--- Sprite animation using multiple texture files.
-- Version : 0.5
--
-- Usage : See "MultiSpriteAnimation.lua" in the Debug Folder of the "Anomaly" theme.
--
-- Changelog :
-- 0.5 : Add Zoom
-- 0.4 : Add BlendMode
-- 0.3 : Add OneShot
-- 0.2 : Use Load instead of creating multiple RageTexture
-- 0.1 : File Creation
local Textures = Var("Textures") or {}
local FPS = Var("FPS") or 60
local OneShot = Var("OneShot") or false
local BlendMode = Var("BlendMode") or ""
local Zoom = Var("Zoom") or 1.0
local Delay = 1.0 / FPS
local AnimationIndex = 0

return Def.Sprite {
    InitCommand = function(self)
        self:zoom(Zoom)
        if BlendMode ~= "" then self:blend(BlendMode) end
        if OneShot then
            self:visible(false)
        else
            self:queuecommand("UpdateTexture")
        end
    end,
    UpdateTextureCommand = function(self)
        AnimationIndex = AnimationIndex + 1
        if AnimationIndex > #Textures then
            AnimationIndex = 1
        end
        self:Load(Textures[AnimationIndex])
        self:sleep(Delay):queuecommand("UpdateTexture")
    end,
    OneShotCommand = function(self)
        self:finishtweening()
        self:visible(true)
        AnimationIndex = 0
        self:queuecommand("UpdateOneShot")
    end,
    UpdateOneShotCommand = function(self)
        AnimationIndex = AnimationIndex + 1
        if AnimationIndex > #Textures then
            AnimationIndex = 0
            self:visible(false)
        else
            self:Load(Textures[AnimationIndex])
            self:sleep(Delay):queuecommand("UpdateOneShot")
        end
    end
}