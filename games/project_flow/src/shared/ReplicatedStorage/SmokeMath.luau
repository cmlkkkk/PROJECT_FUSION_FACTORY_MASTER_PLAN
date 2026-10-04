--!strict
-- Mission 001B smoke fixture. First version was deliberately wrong (a - b) so the
-- first real Studio playtest failed; fixed on disk and propagated by Script Sync.
local SmokeMath = {}

function SmokeMath.add(a: number, b: number): number
	return a + b
end

return SmokeMath
