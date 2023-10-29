--- Sort Manager utility for different sorting algorhythm.
-- Collection of different sorting algorhythmn, and to keep them all
-- in one place.
-- @module SortManager
SortManager = {}

-- Alphabetical sorting
-- Need to either add here or do a new function, for the purpose of better handling number.
SortManager.AlphaSort = function(a, b)
    if type(a) ~= "string" then
        a = a.Name:lower()
        b = b.Name:lower()
    else
        a = a:lower()
        b = b:lower()
    end
    local current_byte_a = 1
    local current_byte_b = 1
    while string.byte(a, current_byte_a) == string.byte(b, current_byte_b) do
        current_byte_a = current_byte_a + 1
        current_byte_b = current_byte_b + 1

        if string.byte(a, current_byte_a) == nil and string.byte(b, current_byte_b) == nil then return false end
        if string.byte(a, current_byte_a) == nil then return true end
        if string.byte(b, current_byte_b) == nil then return false end
    end
    return string.byte(a, current_byte_a) < string.byte(b, current_byte_b)
end