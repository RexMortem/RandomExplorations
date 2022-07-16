--[[
	Credit to the numberphile video:
	https://www.youtube.com/watch?v=uCsD3ZGzMgE&ab_channel=Numberphile
	
	Provided the proof for the Josephus problem. 
	Wrote the bruteforce before watching the entire video, 
	and wrote the proof-based after the key points were delivered. 

	To summarise the proof:
	- First, establish conjecture that for inputs of n that are a power of 2, the output will always be 1.

	- Prove this pattern, and the rest will fall: 
	Powers of 2 are always even. Therefore, in the first pass, all the even values are removed. Half the values are gone.
	Consider n = 8; 2, 4, 6, 8 are eliminated and then the next killer is 1. This is the same as the starting value!
	So, after the first pass, the starting value is the same and the first pass is under the conditions that there are an even number of values.
	Because it is a power of 2, after the total is halved, it is still an even number (unless it reaches n = 1 in which case 1 is the winner)
	Therefore even -> even -> even -> 1 so therefore for powers of 2, the output will always be 1.

	- For some value (power of n) + x: 
	We know that when there is a (power of n) number left, the winner is the same as the starting value. 
	Therefore, we simply need to go through until we get to a (power of n) number left then the winner is the value we land on.
	Therefore, since our value is expressed as (power of n) + x, we must eliminate x values before we find our winner.
	If we eliminate one value (1 eliminates 2) then we land on 3 and therefore this is our winner for x = 1 
	for x = 2, (1 eliminates 2, 3 eliminates 4) then we land on 5 and this is our winner for x = 2
	winner = 1 + 2x
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


local function ConvertToBinary(n)
	local BinaryString = "1"
	
	local GreatestPowerOf2 = 0
	local GreatestPowerResult = 1
	
	while GreatestPowerResult <= n do
		GreatestPowerOf2 += 1
		GreatestPowerResult = math.pow(2, GreatestPowerOf2)
	end
	
	GreatestPowerOf2 -= 1 
	GreatestPowerResult /= 2
	
	n -= GreatestPowerResult
	
	for i = GreatestPowerOf2-1, 0, -1 do
		if n == 0 then 
			BinaryString ..= "0"
			continue
		end
		
		local Value = math.pow(2, i)
		
		if Value <= n then
			n -= Value
			BinaryString ..= "1"
		else
			BinaryString ..= "0"
		end
	end
	
	return BinaryString
end

local function ConvertFromBinary(BinaryString)
	local Sum = 0
	
	for i = 1,#BinaryString do
		local Char = string.sub(BinaryString, i, i)
		
		if Char == "1" then
			Sum += math.pow(2, #BinaryString - i)
		end
	end
	
	return Sum
end

local function JosephusBinaryTrick(n)
	local BinaryNum = ConvertToBinary(n)
	
	local LeadingDigit = string.sub(BinaryNum, 1, 1)
	BinaryNum = string.sub(BinaryNum, 2, #BinaryNum) -- cutting off lead digit
	BinaryNum ..= LeadingDigit -- adding lead digit back at end
	
	return ConvertFromBinary(BinaryNum)
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
