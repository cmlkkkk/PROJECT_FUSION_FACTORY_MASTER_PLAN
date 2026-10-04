--!strict
-- Mission 001B smoke test. Evaluates SmokeMath.add(2, 2) and reports the result
-- twice: a [FLOW_TEST] console line, and a machine-readable StringValue at
-- ReplicatedStorage.TestResults.smoke_math (value "PASS" or "FAIL ...").
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SmokeMath = require(ReplicatedStorage:WaitForChild("SmokeMath"))

local results = ReplicatedStorage:FindFirstChild("TestResults")
if not results then
	results = Instance.new("Folder")
	results.Name = "TestResults"
	results.Parent = ReplicatedStorage
end

local expected = 4
local actual = SmokeMath.add(2, 2)
local passed = actual == expected

local summary = if passed then "PASS" else string.format("FAIL expected=%d actual=%d", expected, actual)

local value = Instance.new("StringValue")
value.Name = "smoke_math"
value.Value = summary
value.Parent = results

if passed then
	print("[FLOW_TEST] PASS smoke_math")
else
	warn(`[FLOW_TEST] FAIL smoke_math expected={expected} actual={actual}`)
end
