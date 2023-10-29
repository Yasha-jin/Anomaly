local t = Def.ActorFrame {}

t[#t + 1] = Def.ActorFrame {
    Def.Quad {
        InitCommand = function(self)
            self:Center()
            self:zoomto(300, 800)
        end
    },
    Def.Quad {
        InitCommand = function(self)
            self:Center()
            self:addx(-140)
            self:zoomto(20, 800)
            self:diffuse(color("#FF0000"))
        end
    },
    BeginCommand = function(self)
        self:baserotationx(-50)
        -- -- self:z(500)
        self:SetFOV(90)
        -- self:zoomz(3)
    end
}

return t