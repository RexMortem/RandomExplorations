--[[
First Draft; need to find a way to ensure that the last person who receives a question hasn't already answered that question in a previous generation
--]]

for d = 1,50 do
	local Generations = 2

	local PlayerTable = {}
	local QuestionCounts = {
	} -- generation 1 first, then generation 2 etc.

	local QuestionCountsRunningTotal = {}


	local Questions = {
		"Why?",
		"How?",
		"God?",
		"Money or no?"
	}

	local Players = {
		"Ed",
		"Flav",
		"Greg",
		"Joe",
		"Ben",
		"Dan",
		"Ethan",
		"Jacob",
		"Jack",
		"Adam",
		"Alistair",
		"Alex"
	}
	
	for i = 1,200 do
		table.insert(Players, string.rep("a", i + 10))
	end
	
	local function cp(t)
		local nt = {}

		for i,v in next, t do
			nt[i] = v
		end

		return nt
	end

	local function Find(t, v)
		for i = 1,#t do
			if t[i] == v then
				return i
			end
		end
	end

	local function MinusTable(CurrentTable)
		local NewTable = cp(Questions)

		for i,v in next,CurrentTable do
			local ni = Find(NewTable, v)

			if ni then
				table.remove(NewTable, ni)
			end
		end

		return NewTable
	end

	local function FindLowestInTable(t)
		local LowestAsked = math.huge

		for i,v in next,t do
			if v < LowestAsked then
				LowestAsked = v
			end
		end
		
		return LowestAsked
	end

	local function PruneQuestions(CurrentTable, QuestionTable) 
		local Lowest = FindLowestInTable(QuestionTable)

		local i = 0

		while i < #CurrentTable do
			i = i + 1

			if not (QuestionTable[CurrentTable[i]] == Lowest) then
				table.remove(CurrentTable, i)
				i = i - 1
			end
		end
	end

	local function BetterConcat(t,concat)
		local str = ""
		concat = concat or " "

		for i,v in next,t do
			str = str .. v .. concat
		end

		return str
	end

	for i,v in next,Questions do 
		QuestionCountsRunningTotal[v] = 0
	end

	for Generation = 1, Generations do
		QuestionCounts[Generation] = {}

		for i,v in next,Questions do
			QuestionCounts[Generation][v] = 0
		end

		local TempPlayerList = {}

		for i,v in next, Players do
			TempPlayerList[i] = {v, i}
		end

		local i = 1
		
		while #TempPlayerList > 0 do
			local PlayerIndex = TempPlayerList[i][2]
			local Player = Players[PlayerIndex]

			if not (PlayerTable[Player]) then
				PlayerTable[Player] = {}
			end

			local NewTable = MinusTable(PlayerTable[Player]) 
			PruneQuestions(NewTable, QuestionCounts[Generation])
			
			if #NewTable > 0 then
				local NewQuestion = NewTable[math.random(1, #NewTable)]
				
				table.insert(PlayerTable[Player], NewQuestion)
				QuestionCounts[Generation][NewQuestion] = QuestionCounts[Generation][NewQuestion] + 1 
				QuestionCountsRunningTotal[NewQuestion] = QuestionCountsRunningTotal[NewQuestion] + 1
				
				table.remove(TempPlayerList, i)
			elseif #TempPlayerList == 1 then
				print("well fuck")
				break
			end
			
			i = (i % #TempPlayerList) + 1
		end
	end

	for i,v in next,QuestionCounts do
		print(i, " : ", BetterConcat(v," "))
	end

	print("total: ", BetterConcat(QuestionCountsRunningTotal, " "))

	print("\n")
	
	--[[
	for i,v in next,PlayerTable do
		print(i, BetterConcat(v, " "))
	end
	--]]
	
	task.wait()
end
