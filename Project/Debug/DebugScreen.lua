local t = Def.ActorFrame {
    BeginCommand = function(self)
        InputManager.CreateInput("escape",
            InputManager.Press,
            ScreenManager.NewScreen,
            ScreenManager.Debug)
    end
}

local MaxRowAmount = 8
local ButtonHorizontalSize = 288
local ButtonVerticalSize = 96
local HorizontalSpacing = 32
local VerticalSpacing = 32
local HorizontalPadding = 64
local VerticalPadding = 40

local Tests = {
    "InputTest",
    "MultiSpriteAnimation",
    "WheelAndSearch",
    "TextInputField",
    "Perspective",
    "Slider",
    "SliderRange"
}

local SelectedTest = Var("SelectedTest") or nil

if SelectedTest == nil then
    for Row, Test in ipairs(Tests) do
        local row = math.fmod(Row - 1, MaxRowAmount)
        local column = math.floor((Row - 1) / MaxRowAmount)
        t[#t + 1] = Def.ActorFrame{
            LoadActorWithParams(PathManager.Button, {
                x = ButtonHorizontalSize, y = ButtonVerticalSize, halign = 0, valign = 0}),
            InitCommand = function(self)
                self:x(HorizontalPadding + (ButtonHorizontalSize * column) + (HorizontalSpacing * column))
                self:y(VerticalPadding + (ButtonVerticalSize * row) + (VerticalSpacing * row))
            end,
            LoadFont("Common Large") .. {
                InitCommand = function(self)
                    self:x(ButtonHorizontalSize / 2)
                    self:y(ButtonVerticalSize / 2)
                    self:settext(Test)
                end,
            },
            MouseInputCommand = function(self)
                ScreenManager.NewScreen(ScreenManager.Debug, {SelectedTest = Test})
            end
        }
    end
else
    t[#t + 1] = Def.ActorFrame{LoadActor("Tests/" .. SelectedTest .. ".lua")}
end

if not SelectedTest then
    t[#t + 1] = Def.ActorFrame {
        LoadFont("Common Large") .. {
            InitCommand = function(self)
                self:halign(0)
                self:x(1920.0 / 32)
                self:y(1080.0 - (1080.0 / 16))
                self:settext("Press F1 to open the legacy option screen.\n" ..
                "Press ESC in any screen to go back to the Debug Screen.")
            end
        }
    }
end

return t