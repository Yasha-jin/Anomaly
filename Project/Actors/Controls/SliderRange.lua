-- Constants
local Textures = Var("Textures") or {Marker = nil, BG = nil, Fill = nil}
local Stretch = Var("Stretch") or false
local Callback = Var("Callback") or nil -- assign a function to this
local MinRange = Var("MinRange") or 0
local MaxRange = Var("MaxRange") or 10
local InitMinRange = Var("InitMinRange") or MinRange
local InitMaxRange = Var("InitMaxRange") or MaxRange
local MarkerOffset = Var("MarkerOffset") or 0
local FunctionTable = {}

-- Variables
local Actors = {
    Slider = nil,
    LeftMarker = nil,
    RightMarker = nil,
    BG = nil,
    Fill = nil
}
local UpdateOrder = {}
local MarkerTex = nil
local BGTex = nil
local RangeTex = nil
local MinX = 0
local MaxX = 0
local LeftIndex = InitMinRange
local RightIndex = InitMaxRange

FunctionTable.UpdateSlider = function(event)
    event = event or ""
    for i = 1, #UpdateOrder do
        UpdateOrder[i]:playcommand("Update")
    end
    if Callback ~= nil then
        Callback(Actors.Slider, {min = LeftIndex, max = RightIndex, event = event})
    end
end

FunctionTable.GetIndex = function(self, params)
    local zoom = self:GetParent():GetZoomX()
    local v1 = (params.MouseX - self:GetParent():GetX()) - (MinX * zoom)
    local v2 = (MaxX * zoom) - (MinX * zoom)
    local percent = v1 / v2
    local result = percent * MaxRange
    return math.floor(result * 1 + 0.5) / 1
end

return Def.ActorFrame {
    Name = "Slider",
    InitCommand = function(self)
        Actors.Slider = self
    end,
    Def.Sprite {
        Name = "BG",
        Texture = Textures.BG,
        InitCommand = function(self)
            Actors.BG = self
            UpdateOrder[1] = self
            BGTex = self:GetTexture()
        end,
        BeginCommand = function(self)
            FunctionTable.UpdateSlider()
        end
    },
    Def.Sprite {
        Name = "Fill",
        Texture = Textures.Fill,
        InitCommand = function(self)
            Actors.Fill = self
            UpdateOrder[4] = self
            RangeTex = self:GetTexture()
        end,
        UpdateCommand = function(self)
            if Stretch then
                self:x(Actors.LeftMarker:GetX() + ((Actors.RightMarker:GetX() - Actors.LeftMarker:GetX()) / 2))
                self:zoomx((Actors.RightMarker:GetX() - Actors.LeftMarker:GetX()) / RangeTex:GetImageWidth())
            else
                self:cropleft(LeftIndex / MaxRange)
                self:cropright(1 - (RightIndex / MaxRange))
            end
        end
    },
    UIElements.SpriteButton(1, 1, Textures.Marker) .. {
        Name = "LeftMarker",
        InitCommand = function(self)
            Actors.LeftMarker = self
            UpdateOrder[2] = self
            MarkerTex = self:GetTexture()
            self:addx(-(BGTex:GetImageWidth() / 2) + MarkerOffset)
            MinX = self:GetX()
        end,
        UpdateCommand = function(self)
            self:x(MinX + ((MaxX - MinX) / MaxRange * (LeftIndex - MinRange)))
        end,
        MouseDownCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            FunctionTable.UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            LeftIndex = clamp(FunctionTable.GetIndex(self, params), MinRange, RightIndex - 1)
            FunctionTable.UpdateSlider("Drag")
        end,
        MouseClickCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            FunctionTable.UpdateSlider("Release")
        end,
        MouseReleaseCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            FunctionTable.UpdateSlider("Release")
        end,
    },
    UIElements.SpriteButton(1, 1, Textures.Marker) .. {
        Name = "RightMarker",
        InitCommand = function(self)
            Actors.RightMarker = self
            UpdateOrder[3] = self
            self:addx(BGTex:GetImageWidth() / 2 - MarkerOffset)
            MaxX = self:GetX()
        end,
        UpdateCommand = function(self)
            self:x(MinX + ((MaxX - MinX) / MaxRange * RightIndex))
        end,
        MouseDownCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            FunctionTable.UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            RightIndex = clamp(FunctionTable.GetIndex(self, params), LeftIndex + 1, MaxRange)
            FunctionTable.UpdateSlider("Drag")
        end,
        MouseClickCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            FunctionTable.UpdateSlider("Release")
        end,
        MouseReleaseCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            FunctionTable.UpdateSlider("Release")
        end,
    },
}