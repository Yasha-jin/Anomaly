local t = Def.ActorFrame {
    BeginCommand = function(self)
        InputManager.CreateInput("F1",
            InputManager.Press,
            SCREENMAN.SetNewScreen,
            {SCREENMAN, "ScreenOptionsService"})
        
        InputManager.CreateInput("F4",
            InputManager.Press,
            SCREENMAN.SetNewScreen,
            {SCREENMAN, "ScreenSelectMusic"})
        
        -- GAMESTATE:SetCurrentStyle("single")
        -- local pro = ProfileManager.GetProfileIDs()
        -- -- ProfileManager.SetProfile(pro[math.random(1,PROFILEMAN:GetNumLocalProfiles())])
        -- ProfileManager.SetProfile(0)
        -- ms.ok(PROFILEMAN:GetPlayerName(0))
    end
}

t[#t + 1] = LoadActorWithParams(ScreenManager.CurrentScreen, ScreenManager.ScreenParams)
t[#t + 1] = LoadActor("MouseInput.lua")

return t