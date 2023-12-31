local Textures = Var("Textures") or {Marker = nil, BG = nil, Fill = nil}
local Stretch = Var("Stretch") or false
local Callback = Var("Callback") or nil -- assign a function to this
local MinRange = Var("MinRange") or 0
local MaxRange = Var("MaxRange") or 10
local InitMinRange = Var("InitMinRange") or MinRange
local InitMaxRange = Var("InitMaxRange") or MaxRange
local MarkerOffset = Var("MarkerOffset") or 0
local ResetSpeed = Var("ResetSpeed") or 0.5

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
local GrabedMarker = nil

UpdateSlider = function(event)
    event = event or ""
    for i = 1, #UpdateOrder do
        if event == "Reset" or event == "Set" then
            UpdateOrder[i]:stoptweening():decelerate(ResetSpeed):playcommand("Update")
        else
            UpdateOrder[i]:stoptweening():playcommand("Update")
        end
    end
    if Callback ~= nil then
        Callback(Actors.Slider, {min = LeftIndex, max = RightIndex, event = event})
    end
end

GetIndex = function(self, params)
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
    ResetCommand = function(self)
        LeftIndex = InitMinRange
        RightIndex = InitMaxRange
        UpdateSlider("Reset")
    end,
    SetIndexCommand = function(self, params)
        LeftIndex = params.left
        RightIndex = params.right
        UpdateSlider("Set")
    end,
    SetRangeCommand = function(self, params)
        MinRange = params.min
        MaxRange = params.max
        UpdateSlider("Set")
    end,
    UIElements.SpriteButton(1, 1, Textures.BG) .. {
        Name = "BG",
        InitCommand = function(self)
            Actors.BG = self
            UpdateOrder[1] = self
            BGTex = self:GetTexture()
        end,
        BeginCommand = function(self)
            UpdateSlider("Init")
        end,
        MouseDownCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            if RightIndex - GetIndex(self, params) < GetIndex(self, params) - LeftIndex then
                GrabedMarker = Actors.RightMarker
            else
                GrabedMarker = Actors.LeftMarker
            end
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            if GrabedMarker == Actors.RightMarker then
                RightIndex = clamp(GetIndex(self, params), LeftIndex + 1, MaxRange)
            else
                LeftIndex = clamp(GetIndex(self, params), MinRange, RightIndex - 1)
            end
            UpdateSlider("Drag")
        end,
        MouseClickCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            GrabedMarker = nil
            UpdateSlider("Release")
        end,
        MouseReleaseCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            GrabedMarker = nil
            UpdateSlider("Release")
        end,
    },
    UIElements.SpriteButton(1, 1, Textures.Fill) .. {
        Name = "Fill",
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
        end,
        MouseDownCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            if RightIndex - GetIndex(self, params) < GetIndex(self, params) - LeftIndex then
                GrabedMarker = Actors.RightMarker
            else
                GrabedMarker = Actors.LeftMarker
            end
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            if GrabedMarker == Actors.RightMarker then
                RightIndex = clamp(GetIndex(self, params), LeftIndex + 1, MaxRange)
            else
                LeftIndex = clamp(GetIndex(self, params), MinRange, RightIndex - 1)
            end
            UpdateSlider("Drag")
        end,
        MouseClickCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            GrabedMarker = nil
            UpdateSlider("Release")
        end,
        MouseReleaseCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            GrabedMarker = nil
            UpdateSlider("Release")
        end,
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
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            LeftIndex = clamp(GetIndex(self, params), MinRange, RightIndex - 1)
            UpdateSlider("Drag")
        end,
        MouseClickCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            UpdateSlider("Release")
        end,
        MouseReleaseCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            UpdateSlider("Release")
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
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            RightIndex = clamp(GetIndex(self, params), LeftIndex + 1, MaxRange)
            UpdateSlider("Drag")
        end,
        MouseClickCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            UpdateSlider("Release")
        end,
        MouseReleaseCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            UpdateSlider("Release")
        end,
    },
}