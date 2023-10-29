local t = Def.ActorFrame {}

t[#t + 1] = Def.ActorFrame {
    LoadFont("Common Large") .. {
        InitCommand = function(self)
            self:x(1920.0 / 2)
            self:y(1080.0 / 2)
            self:settext("Input Examples + Explanation :\n\n" ..
                "F : Execute a function inside a table.\n" ..
                "G : Execute a function inside a table with an argument.\n" ..
                "H : Execute a function inside a table with multiple arguments.\n" ..
                "J : Execute a command from the Actor.\n" ..
                "K : Execute a command from the Actor with an argument.\n" ..
                "L : Execute a command from the Actor with multiple arguments.\n" ..
                "C : Execute a function inside a Singleton. (This will move you to the legacy option screen.)\n" ..
                "V : Execute a global function from scripts.\n" ..
                "B : Execute a global function with argument from scripts.\n")
        end,
    },
}

local FunctionTable = {}
FunctionTable.InputTest = function() ms.ok("The F key as been pressed.") end
FunctionTable.SingularArgTest = function(arg1) ms.ok(arg1) end
FunctionTable.MultiArgsTest = function(arg1, arg2, arg3) ms.ok(arg1 .. arg2 .. arg3) end

t[#t + 1] = Def.ActorFrame {
    -- Adding input during Init don't work, as the screen is still loading, so do it in Begin instead.
    BeginCommand = function(self)
        InputManager.CreateInput("f", InputManager.Press, FunctionTable, "InputTest")

        InputManager.CreateInput("g",
            InputManager.Press,
            FunctionTable,
            "SingularArgTest",
            "The G key as been pressed.")
        
        InputManager.CreateInput("h",
            InputManager.Press,
            FunctionTable,
            "MultiArgsTest",
            {"The H key ", "as been ", "pressed."})
        
        InputManager.CreateInput("j",
            InputManager.Press,
            self, -- self is a table yes.
            "queuecommand",
            {self, "CommandTest"}) -- self methods use ":" which automatically pass self,
            -- but here you need to pass it for the method to work.
        
        InputManager.CreateInput("k",
            InputManager.Press,
            self,
            "playcommand",
            {self, "CommandTestWithArg", {"The K key as been pressed."}})
        
        InputManager.CreateInput("l",
            InputManager.Press,
            self,
            "playcommand",
            {self, "CommandTestWithMultiArgs", {"The L key ", "as been ", "pressed."}})
        
        InputManager.CreateInput("c",
            InputManager.Press,
            SCREENMAN,
            "SetNewScreen",
            {SCREENMAN, "ScreenOptionsService"})
        
        InputManager.CreateInput("v",
            InputManager.Press,
            _G, -- _G is the global table, use this when using a global function that is not inside a table.
            "DebugInputTest")
        
        InputManager.CreateInput("b",
            InputManager.Press,
            _G,
            "DebugInputTest",
            {"The B key as been pressed."})
    end,
    CommandTestCommand = function(self)
        ms.ok("The J key as been pressed.")
    end,
    CommandTestWithArgCommand = function(self, arg)
        ms.ok(unpack(arg))
    end,
    CommandTestWithMultiArgsCommand = function(self, args)
        local text = ""
        for _, arg in ipairs(args) do
            text = text .. arg
        end
        ms.ok(text)
    end,
}

return t