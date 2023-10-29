-- yoink from Til Death

local screenName = Var("LoadingScreen") or ...
BUTTON:ResetButtonTable(screenName)

local function UpdateLoop()
    local mouseX = INPUTFILTER:GetMouseX()
    local mouseY = INPUTFILTER:GetMouseY()
    BUTTON:UpdateMouseState()
    return false
end

local t = Def.ActorFrame{
    OnCommand = function(self)
		self:SetUpdateFunction(UpdateLoop)
        self:SetUpdateFunctionInterval(1 / DISPLAY:GetDisplayRefreshRate())
        SCREENMAN:GetTopScreen():AddInputCallback(BUTTON.InputCallback)
    end
}

return t
