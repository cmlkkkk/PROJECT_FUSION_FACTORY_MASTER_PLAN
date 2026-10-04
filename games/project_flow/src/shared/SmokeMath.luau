--!strict
-- Mission 001B smoke fixture. DELIBERATELY WRONG on first commit so the first
-- real Studio playtest must fail. The fix (a + b) is applied on disk afterwards.
local SmokeMath = {}

function SmokeMath.add(a: number, b: number): number
	return a - b
end

return SmokeMath
