local t = Def.ActorFrame {}

local searchstring = ""
local curSearchDelay = 2

local function _input(event)
	if event.type ~= "InputEventType_Release" then
		if event.button == "Back" then
			curSearchDelay = 0
			local tind = getTabIndex()
			whee:SongSearch(searchstring)
			resetTabIndex(0)
			MESSAGEMAN:Broadcast("TabChanged", {from = tind, to = 0})
			MESSAGEMAN:Broadcast("EndingSearch")
		elseif event.button == "Start" then
			local tind = getTabIndex()
			resetTabIndex(0)
			MESSAGEMAN:Broadcast("EndingSearch")
			MESSAGEMAN:Broadcast("TabChanged", {from = tind, to = 0})
		elseif event.DeviceInput.button == "DeviceButton_space" then -- add space to the string
			searchstring = searchstring .. " "
		elseif event.DeviceInput.button == "DeviceButton_backspace" then
			searchstring = searchstring:sub(1, -2) -- remove the last element of the string
		elseif event.DeviceInput.button == "DeviceButton_delete" then
			searchstring = ""
		else
			local CtrlPressed = INPUTFILTER:IsControlPressed()
			if event.DeviceInput.button == "DeviceButton_v" and CtrlPressed then
                -- ms.ok(string.byte(Arch.getClipboard(), 1, string.len(Arch.getClipboard())))
                for i=1,string.len(Arch.getClipboard()) do Trace(string.byte(Arch.getClipboard(),i)) end
				searchstring = searchstring .. Arch.getClipboard()
			elseif
			--if not nil and (not a number or (ctrl pressed and not online))
				event.char and event.char:match('[%%%+%-%!%@%#%$%^%&%*%(%)%=%_%.%,%:%;%\'%"%>%<%?%/%~%|%w%[%]%{%}%`%\\]') and
					(not tonumber(event.char) or CtrlPressed)
			 then
				searchstring = searchstring .. event.char
			end
		end
		if lastsearchstring ~= searchstring then
			MESSAGEMAN:Broadcast("UpdateString")
			curSearchDelay = totalSearchDelay
			-- MESSAGEMAN:Broadcast("SearchTimer")
			lastsearchstring = searchstring
		end
	end
end

t[#t + 1] = Def.ActorFrame {
	BeginCommand = function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(_input)
	end,
    LoadFont("Common Normal") ..
    {
        InitCommand = function(self)
            self:Center():maxwidth(470)
            self:diffuse(color("#FFFFFF"))
            self:settext("Search")
        end,
        SetCommand = function(self)
            if active then
                self:settext(searchstring)
            elseif not active and searchstring ~= "" then
                self:settext(searchstring)
            else
                self:settext(searchstring)
            end
        end,
        UpdateStringMessageCommand = function(self)
            self:queuecommand("Set")
        end
    },
}

return t