--- Math helper/utility.
-- Just contain mathematical function, some may come from _fallback,
-- but without unnecessary stuff such as Trace. May also change variable name
-- to be actually readable.
-- @module Math
Math = {}

-- the wrap function from _fallback, but without all the Trace
Math.wrap = function(value, max_value)
	if value < 0 then
		value = value + (math.ceil(-value / max_value) + 1) * max_value
	end
	return math.mod(value, max_value)
end