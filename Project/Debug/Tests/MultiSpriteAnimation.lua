local t = Def.ActorFrame {}

t[#t + 1] = Def.ActorFrame {
    LoadFont("Common Large") .. {
        InitCommand = function(self)
            self:x(1920.0 / 4)
            self:y(1080.0 / 6)
            self:settext("Spritesheet Animation")
        end,
    },
}

t[#t + 1] = Def.ActorFrame {
    LoadFont("Common Large") .. {
        InitCommand = function(self)
            self:x(1920.0 / 2)
            self:y(1080.0 / 6)
            self:settext("Multi Sprite Animation (OneShot)\nPress T to play animation.")
        end,
    },
}

t[#t + 1] = Def.ActorFrame {
    LoadFont("Common Large") .. {
        InitCommand = function(self)
            self:x(1920.0 - (1920.0 / 4))
            self:y(1080.0 / 6)
            self:settext("Multi Sprite Animation (Loop)")
        end,
    },
}

t[#t + 1] = Def.Sprite {
    Texture = PathManager.DebugSpritesheet,
    BeginCommand = function(self)
        self:x(1920.0 / 4)
        self:y(1080.0 / 2)
        self:SetAllStateDelays((1000 / 60) / 1000 * 1)
    end
}

-- Code below is meant to test performance of the Animated Sprite when using lot of them.

-- for i = 1, 1080 do
--     t[#t + 1] = Def.Sprite {
--         Texture = PathManager.DebugSpritesheet,
--         BeginCommand = function(self)
--             self:x(1920.0 / 2)
--             self:y(1 * i)
--             self:SetAllStateDelays((1000 / 60) / 1000 * 1)
--         end
--     }
-- end

local textures = FILEMAN:GetDirListing(PathManager.DebugMultiSprite, false, true)

t[#t + 1] = LoadActorWithParams(PathManager.MultiSprite, {
        Textures = textures, OneShot = true}) .. {
    BeginCommand = function(self)
        self:x(1920.0 / 2)
        self:y(1080.0 / 2)
        self:queuecommand("OneShot")
        InputManager.CreateInput("t", InputManager.Press, self, "queuecommand", {self, "OneShot"})
    end
}

t[#t + 1] = LoadActorWithParams(PathManager.MultiSprite, {
        Textures = textures}) .. {
    BeginCommand = function(self)
        self:x(1920.0 - (1920.0 / 4))
        self:y(1080.0 / 2)
    end
}

-- Code below is meant to test performance of the MultiSprite when using lot of them.

-- for i = 1, 1080 do
--     t[#t + 1] = LoadActorWithParams(PathManager.MultiSprite, {
--                     Textures = textures}) .. {
--         BeginCommand = function(self)
--             self:x(1920.0 / 2)
--             self:y(1 * i)
--         end
--     }
-- end

return t