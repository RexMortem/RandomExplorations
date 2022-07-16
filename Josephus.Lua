--[[
	Credit to the numberphile video:
	https://www.youtube.com/watch?v=uCsD3ZGzMgE&ab_channel=Numberphile
	
	Provided the proof for the Josephus problem. 
	Wrote the bruteforce before watching the entire video, 
	and wrote the proof-based after the key points were delivered. 
--]]

local function FindNextIndex(Table, StartIndex)
	local i = StartIndex 
	local Len = #Table
	
	repeat
		i = (i % Len) + 1
		
		if Table[i] then
			return i
		end
		
		i = (i % Len) + 1
	until (i == StartIndex) -- i being start index signifies completed one whole iteration
end

local function JosephusBruteForce(n)
	local MembersAlive = {}
	
	for i = 1,n do
		MembersAlive[i] = i
	end
	
	local CurrentIndex = 1
	
	while #MembersAlive > 1 do
		-- CurrentIndex takes out next alive index
		local IndexToBeRemoved = FindNextIndex(MembersAlive, CurrentIndex)

		if CurrentIndex > IndexToBeRemoved then
			CurrentIndex -= 1
		end
		
		table.remove(MembersAlive, IndexToBeRemoved)
		
		CurrentIndex = FindNextIndex(MembersAlive, CurrentIndex)
	end
	
	return MembersAlive[1]
end

local function Josephus(n)
	--[[
		if we cared about speed, we would use a loop and powers of 2 
		to go up to where it's lower than n (greatest power of 2 smaller than n)
		instead of calculating the log since that's a lot of dp and calculation
		that we are essentially discarding because we don't need it
	--]]
	
	local NValue = math.floor(math.log(n, 2))	
	local PowerOfN = math.pow(2, NValue)
	
	return 1 + (2 * (n - PowerOfN))
end

for i = 1, 41 do
	print("josephus: ", i, Josephus(i))
end
