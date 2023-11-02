--- Input Manager for all input related stuff.
-- Help a lot to not repeatly copy paste input setup in every file
-- which need inputs. See "InputTest.lua" in Debug for usage examples.
-- @module InputManager

-- Aliases for InputEventType
InputManager = {
    Press = "InputEventType_FirstPress",
    Repeat = "InputEventType_Repeat",
    Release = "InputEventType_Release"
}

-- useless function, it's just there for
-- showcasing executing a global function
-- in the InputTest from the DebugScreen.
DebugInputTest = function(arg)
    if arg ~= nil then
        ms.ok(arg)
    else
        ms.ok("DebugInputTest")
    end
end

InputManager.CreateInput = function(Button, Type, Callback, args)
    local args = args or {}
    if type(args) ~= "table" then
        args = {args}
    end
	SCREENMAN:GetTopScreen():AddInputCallback(function(event)
        -- ms.ok(event["DeviceInput"])
        if event.type == Type then
			if event.DeviceInput.button == "DeviceButton_" .. Button then
                Callback(unpack(args))
            end
		end
	end)
end