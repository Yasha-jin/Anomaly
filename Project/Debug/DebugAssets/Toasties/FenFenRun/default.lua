-- Little hack to get the directory of the script.
-- Intended to be used in case of multi assets usage.
-- Only work if an image is set, just think of it as a banner.
local DirIndex = getToastyAssetPath("image"):match(".*".."%/".."()")
local workingDir = string.sub(getToastyAssetPath("image"), 1, DirIndex - 1)

-- Multiply command value that are relative to the screen with this.
-- Mean to make the toasty work as intended on all aspect ratio.
local scaleY = SCREEN_HEIGHT / 1080.0
local scaleX = SCREEN_WIDTH / 1920.0

local t = Def.ActorFrame {
    Def.Sprite {
        InitCommand = function(self)
            self:Load(workingDir .. "ray.png")
            self:Center()
        end,
        StartTransitioningCommand = function(self)
            self:diffusealpha(1)
            self:zoom(0)
            self:linear(0.5)
            self:addrotationz(45)
            self:zoom(2 * scaleY)
            self:linear(1)
            self:addrotationz(45 * 2)
            self:linear(0.5)
            self:addrotationz(45)
            self:zoom(0)
            self:linear(0)
            self:diffusealpha(0)
        end
    },
    Def.Sprite {
        InitCommand = function(self)
            self:Load(workingDir .. "FenFenRun 6x4.png")
            self:Center()
            self:SetAllStateDelays((1000 / 60) / 1000 * 1)
        end,
        StartTransitioningCommand = function(self)
            self:diffusealpha(1)
            self:zoom(0)
            self:linear(0.5)
            self:zoom(2 * scaleY)
            self:sleep(1)
            self:linear(0.5)
            self:zoom(0)
            self:linear(0)
            self:diffusealpha(0)
        end
    }
}
return t
