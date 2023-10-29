local x = Var("x") or 128
local y = Var("y") or 64
local halign = Var("halign") or 0.5
local valign = Var("valign") or 0.5
local diffuse = Var("diffuse") or "#969696"
local texture = Var("texture") or ""
local use_texture_size = Var("use_texture_size")
return UIElements.QuadButton(1, 1) .. {
    InitCommand = function(self)
        if texture ~= "" then
            self:Load(texture)
            if not use_texture_size then
                self:zoomto(x, y)
            end
        else
            self:diffuse(color(diffuse))
            self:zoomto(x, y)
        end
        self:halign(halign)
        self:valign(valign)
    end,
    MouseDownCommand = function(self, params)
        if self:GetParent():GetCommand("MouseInput") then
            self:GetParent():queuecommand("MouseInput")
        end
    end
}