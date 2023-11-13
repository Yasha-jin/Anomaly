local t =
    Def.ActorFrame {
    Def.Sprite {
        InitCommand = function(self)
            self:xy(SCREEN_WIDTH + 150, SCREEN_CENTER_Y)
            self:Load(getToastyAssetPath("image"))
            self:zoom(0.25)
        end,
        StartTransitioningCommand = function(self)
            self:diffusealpha(1)
			self:linear(0.5)
			self:x(SCREEN_WIDTH - 150)
			self:addrotationz(-360)
			self:sleep(0.7)
			self:linear(0.5)
			self:x(SCREEN_WIDTH + 150)
			self:addrotationz(360)
			self:linear(0)
			self:diffusealpha(0)
        end
    },
    Def.Sound {
        InitCommand = function(self)
            self:load(getToastyAssetPath("sound"))
        end,
        StartTransitioningCommand = function(self)
            self:sleep(0.5)
			self:queuecommand("PlaySound")
        end,
		PlaySoundCommand = function(self)
			self:play()
		end
    }
}
return t
