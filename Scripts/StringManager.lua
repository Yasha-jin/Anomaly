--- String helper/utility.
-- Functions related to string value, such as pattern matching.
-- @module StringManager

function GetFileName(url)
    local name = url:match("[^/]+$")
    if name:find("%.") then
        name = string.sub(name, 0, name:find("%.") - 1)
    end
    return name
end

function GetFileNameWithExtension(url)
    return url:match("[^/]+$")
end
  
function GetFileExtension(url)
    if not url:find("%.") then
        return ""
    end
    return url:match("[^.]+$")
end

-- Unit Tests
assert(GetFileName("test") == "test",
'Test : GetFileName("test") == "test". Failed. Returned value : ' .. GetFileName("test"))
assert(GetFileName("test.ogg") == "test",
'Test : GetFileName("test.ogg") == "test". Failed. Returned value : ' .. GetFileName("test.ogg"))
assert(GetFileName("Hello/World/test") == "test",
'Test : GetFileName("Hello/World/test") == "test". Failed. Returned value : ' .. GetFileName("Hello/World/test"))
assert(GetFileName("Hello/World/test.ogg") == "test",
'Test : GetFileName("Hello/World/test.ogg") == "test". Failed. Returned value : ' .. GetFileName("Hello/World/test.ogg"))
assert(GetFileExtension("test") == "",
'Test : GetFileExtension("test") == "". Failed. Returned value : ' .. GetFileExtension("test"))
assert(GetFileExtension("test.ogg") == "ogg",
'Test : GetFileExtension("test.ogg") == "test". Failed. Returned value : ' .. GetFileExtension("test.ogg"))
assert(GetFileExtension("Hello/World/test") == "",
'Test : GetFileExtension("Hello/World/test") == "". Failed. Returned value : ' .. GetFileExtension("Hello/World/test"))
assert(GetFileExtension("Hello/World/test.ogg") == "ogg",
'Test : GetFileExtension("Hello/World/test.ogg") == "ogg". Failed. Returned value : ' .. GetFileExtension("Hello/World/test.ogg"))