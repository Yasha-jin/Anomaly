local t = Def.ActorFrame {}

local texts = {"[(世界你好)]", "[(ハロー・ワールド)]", "[(Ztestg)]", "[(안녕하세요)]"}

local spacing = 50

for Row, Text in ipairs(texts) do
    for i = 0, 2 do
        t[#t + 1] = Def.ActorFrame {
            Def.Quad {
                InitCommand = function(self)
                    self:zoomto(spacing, spacing)
                    self:halign(1)
                    self:valign(1)
                end
            },
            Def.Quad {
                InitCommand = function(self)
                    self:zoomto(spacing, spacing)
                    self:halign(0)
                    self:valign(0)
                end
            },
            LoadFont("Common Large") .. {
                InitCommand = function(self)
                    self:addx(spacing)
                    self:halign(0)
                    self:valign(0.5 * i)
                    self:settext(Text)
                end,
            },
            BeginCommand = function(self)
                self:addx(200 + (600 * i))
                self:addy(150 * Row)
            end
        }
    end
    t[#t + 1] = Def.Quad {
        BeginCommand = function(self)
            self:zoomto(1920, 1)
            self:addy(150 * Row)
            self:addx(1920 / 2)
        end
    }
end

return t