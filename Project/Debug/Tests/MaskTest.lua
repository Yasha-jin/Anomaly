local t = Def.ActorFrame {}

t[#t + 1] = Def.ActorFrame {
    Def.Quad {
        InitCommand = function(self)
            self:Center()
            self:zoomto(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
            self:diffuse(color("#808080"))
        end
    }
}

-- The mask source must be behind the dest to work.
-- The mask source will affect EVERY sprite assigned as a dest if they are in front of it.

-- Circle
t[#t + 1] = Def.ActorFrame {
    Def.Sprite {
        Name = "Source",
        Texture = PathManager.DebugMaskCircle,
        BeginCommand = function(self)
            self:Center()
            self:MaskSource()
        end
    },
    Def.Sprite {
        Name = "Dest",
        Texture = PathManager.DebugProfile,
        BeginCommand = function(self)
            self:Center()
            self:MaskDest()
            self:zoom(0.5)
        end
    }
}


-- Triangle
t[#t + 1] = Def.ActorFrame {
    Def.Sprite {
        Name = "Source",
        Texture = PathManager.DebugMaskTriangle,
        BeginCommand = function(self)
            self:Center()
            self:MaskSource()
        end
    },
    Def.Sprite {
        Name = "Dest",
        Texture = PathManager.DebugProfile,
        BeginCommand = function(self)
            self:Center()
            self:MaskDest()
            self:zoom(0.5)
        end
    },
    BeginCommand = function(self)
        self:addx(-256-64)
    end
}


-- Pentagon
t[#t + 1] = Def.ActorFrame {
    Def.Sprite {
        Name = "Source",
        Texture = PathManager.DebugMaskPentagon,
        BeginCommand = function(self)
            self:Center()
            self:MaskSource()
        end
    },
    Def.Sprite {
        Name = "Dest",
        Texture = PathManager.DebugProfile,
        BeginCommand = function(self)
            self:Center()
            self:MaskDest()
            self:zoom(0.5)
        end
    },
    BeginCommand = function(self)
        self:addx(256+64)
    end
}

return t