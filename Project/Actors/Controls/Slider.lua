local Textures = Var("Textures") or {Marker = nil, BG = nil, Fill = nil}
local Stretch = Var("Stretch") or false
local Callback = Var("Callback") or nil -- assign a function to this
local MessageOnMouseOver = Var("MessageOnMouseOver") or nil -- message broadcasted on mouseOver
local MessageOnMouseOut = Var("MessageOnMouseOut") or nil -- same but mouseOut
local MinRange = Var("MinRange") or 0
local MaxRange = Var("MaxRange") or 10
local InitRange = Var("InitRange") or MinRange
local MarkerOffset = Var("MarkerOffset") or 0
local ResetSpeed = Var("ResetSpeed") or 0.5

local Actors = {
    Slider = nil,
    Marker = nil,
    BG = nil,
    Fill = nil
}
local UpdateOrder = {}
local MarkerTex = nil
local BGTex = nil
local RangeTex = nil
local MinX = 0
local MaxX = 0
local Index = InitRange

local UpdateSlider = function(event)
    event = event or ""
    for i = 1, #UpdateOrder do
        if event == "Reset" or event == "Set" then
            UpdateOrder[i]:stoptweening():decelerate(ResetSpeed):playcommand("Update")
        else
            UpdateOrder[i]:stoptweening():playcommand("Update")
        end
    end
    if Callback ~= nil then
        Callback(Actors.Slider, {value = Index, event = event})
    end
end

local GetIndex = function(self, params)
    local zoom = self:GetParent():GetZoomX()
    local v1 = (params.MouseX - self:GetParent():GetX()) - (MinX * zoom)
    local v2 = (MaxX * zoom) - (MinX * zoom)
    local percent = v1 / v2
    local result = percent * (MaxRange - MinRange)
    return (math.floor(result * 1 + 0.5) / 1) + MinRange
end

return Def.ActorFrame {
    Name = "Slider",
    InitCommand = function(self)
        Actors.Slider = self
    end,
    ResetCommand = function(self)
        Index = InitRange
        UpdateSlider("Reset")
    end,
    SetIndexCommand = function(self, params)
        Index = params.value
        UpdateSlider("Set")
    end,
    SetRangeCommand = function(self, params)
        MinRange = params.min
        MaxRange = params.max
        UpdateSlider("Set")
    end,
    SendHoverCommand = function(self)
        self:stoptweening()
        MESSAGEMAN:Broadcast(MessageOnMouseOver)
    end,
    SendUnHoverCommand = function(self)
        MESSAGEMAN:Broadcast(MessageOnMouseOut)
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
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            Index = clamp(GetIndex(self, params), MinRange, MaxRange)
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
        MouseOverCommand = function(self)
            if not MessageOnMouseOver then return end
            if isOver(self) then
                self:GetParent("Slider"):playcommand("SendHover")
            end
        end,
        MouseOutCommand = function(self)
            if not MessageOnMouseOut then return end
            self:GetParent("Slider"):playcommand("SendUnhover")
        end
    },
    UIElements.SpriteButton(1, 1, Textures.Fill) .. {
        Name = "Fill",
        InitCommand = function(self)
            Actors.Fill = self
            UpdateOrder[3] = self
            RangeTex = self:GetTexture()
            if Stretch then
                self:addx(-(BGTex:GetImageWidth() / 2))
                self:halign(0)
                self:addx(MarkerOffset / 2)
            end
        end,
        UpdateCommand = function(self)
            if Stretch then
                self:zoomx((Actors.Marker:GetX() - self:GetX()) / RangeTex:GetImageWidth())
            else
                self:cropright(1 - ((Index - MinRange) / (MaxRange - MinRange)))
            end
        end,
        MouseDownCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            Index = clamp(GetIndex(self, params), MinRange, MaxRange)
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
        MouseOverCommand = function(self)
            if not MessageOnMouseOver then return end
            if isOver(self) then
                self:GetParent("Slider"):playcommand("SendHover")
            end
        end,
        MouseOutCommand = function(self)
            if not MessageOnMouseOut then return end
            self:GetParent("Slider"):playcommand("SendUnhover")
        end
    },
    UIElements.SpriteButton(1, 1, Textures.Marker) .. {
        Name = "Marker",
        InitCommand = function(self)
            Actors.Marker = self
            UpdateOrder[2] = self
            MarkerTex = self:GetTexture()
            MaxX = self:GetX() + (BGTex:GetImageWidth() / 2 - MarkerOffset)
            self:addx(-(BGTex:GetImageWidth() / 2) + MarkerOffset)
            MinX = self:GetX()
        end,
        UpdateCommand = function(self)
            self:x(MinX + ((MaxX - MinX) / (MaxRange - MinRange) * (Index - MinRange)))
        end,
        MouseDownCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            UpdateSlider("Press")
        end,
        MouseHoldCommand = function(self, params)
            if params.event ~= "DeviceButton_left mouse button" then return end
            Index = clamp(GetIndex(self, params), MinRange, MaxRange)
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
        MouseOverCommand = function(self)
            if not MessageOnMouseOver then return end
            if isOver(self) then
                self:GetParent("Slider"):playcommand("SendHover")
            end
        end,
        MouseOutCommand = function(self)
            if not MessageOnMouseOut then return end
            self:GetParent("Slider"):playcommand("SendUnhover")
        end
    }
}