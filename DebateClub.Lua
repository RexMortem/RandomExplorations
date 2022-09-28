--[[
First Draft; need to find a way to ensure that the last person who receives a question hasn't already answered that question in a previous generation

Second Draft; may or may not have completely overhauled the iterations or that may have been in the first draft.
Switched to iterating through questions first.
Then, since we may get a situation where in the last 4 iterations in this case (or the last question iteration round), where the random allocations
create an invalid permutation. Therefore, we must make a necessary number of swaps in order to ensure that it is valid.
Mainly though, what heuristic should we use in order to make a correct swap? Of course, we can check whether a swap is valid. But if there are 
more than one in tempplayers after the list, then is there a way to make better swaps? 
The other option was to code some sort of algorithm which completely took control of the last round without any interaction from the first loop for this round.

To do: finish the algorithm, and then maybe think of a way to make better swaps but it should be sufficient to finish the algorithm. 
Worst case, we can just brute-force the swaps tbh 
Should we remove swapped players from the pool though?

I have realised that my code often becomes messy and unrecognisable to myself; the whitespace is good, but the variable names and processes get confusing. 
I need to think of some conventions for naming I think
Or maybe just use a better colour scheme because it looks more readable in github editor lol
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
		"Alex",
	}
	
	--[[
	for i = 1,200 do
		table.insert(Players, string.rep("a", i + 10))
	end
	
	--]]
	
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
	
	local function FindSubsetWhoCanBeAsked(Question, PassedPlayers)
		local Subset = {}
		
		for i,v in next,PassedPlayers do
			local PlayerIndex = v[2]
			local Player = PlayerTable[PlayerIndex]
			
			local Result = Find(Player, Question)
			
			if not Result then
				table.insert(Subset, i)
			end
		end
		
		return Subset
	end

	local function BetterConcat(t,concat)
		local str = ""
		concat = concat or " "

		for i,v in next,t do
			str = str .. v .. concat
		end

		return str
	end
	
	local function CheckForValidity(Question, Player)
		
	end
	
	local function Swap(Player1, Player2, Question)
		table.insert(Player1, Player2[#Player2])
		Player2[#Player2] = Question
	end
	
	for i,v in next,Questions do 
		QuestionCountsRunningTotal[v] = 0
	end
	
	for i,v in next, Players do
		PlayerTable[i] = {}
	end
	
	local QuestionUpperLimit = math.ceil(#Players/#Questions)
	
	for Generation = 1, Generations do
		QuestionCounts[Generation] = {}

		for i,Question in next,Questions do
			QuestionCounts[Generation][Question] = 0
		end

		local TempPlayerList = {}

		for i,v in next, Players do
			TempPlayerList[i] = {v, i}
		end

		local qi = 1 -- question index
		local dn = 0

		local LastSwaps = {}
		local Failed = false
		
		while #TempPlayerList > 0 do
			local Question = Questions[qi]
			if QuestionCounts[Generation][Question] >= QuestionUpperLimit then 
				qi = (qi % #Questions) + 1 
				continue
			end
			
			local PlayerIndexes = FindSubsetWhoCanBeAsked(Question, TempPlayerList)
			
			if #PlayerIndexes == 0 then
				dn = dn + 1 
				
				if dn > #Questions then
					Failed = true
					break
				end
				
				qi = (qi % #Questions) + 1 
				continue
			end
			
			local SelectedIndex = PlayerIndexes[math.random(1, #PlayerIndexes)]
			
			local SelectedPlayerIndex = TempPlayerList[SelectedIndex][2]

			table.insert(PlayerTable[SelectedPlayerIndex], Question)
			QuestionCounts[Generation][Question] = QuestionCounts[Generation][Question] + 1 
			QuestionCountsRunningTotal[Question] = QuestionCountsRunningTotal[Question] + 1

			table.remove(TempPlayerList, SelectedIndex)
			
			-- for the last iteration of 4, record for optimal permutations 

			if (QuestionCounts[Generation][Question] == QuestionUpperLimit) then
				table.insert(LastSwaps, {Players[SelectedPlayerIndex],SelectedPlayerIndex})
			end
			
			qi = (qi % #Questions) + 1 
		end
		
		if Failed then -- have to do swaps 
			print("Failure")
			
			local QuestionsLeft = {}
			
			for question, count in next,QuestionCounts[Generation] do
				if count < QuestionUpperLimit then
					table.insert(QuestionsLeft, question)
				end
			end
			local qi = 1
			
			local QuestionCountTable = QuestionCounts[Generation]
			
			while #QuestionsLeft > 0 do
				local Question = QuestionsLeft[qi]
				
				print("last swap count", #LastSwaps, #QuestionsLeft)
				local PossibleSwappers = FindSubsetWhoCanBeAsked(Question, LastSwaps)
				
				for _,PossibleSwapper in next, PossibleSwappers do
					local PossibleSwapperData = PlayerTable[PossibleSwapper[2]]
					local LatestQuestion = PossibleSwapperData[#PossibleSwapperData]
					
					for i,PossiblePlayer in next, TempPlayerList do
						if CheckForValidity(PossiblePlayer, LatestQuestion) then
							Swap(PossiblePlayer, PossibleSwapper, Question)
							QuestionCountTable[Question] = QuestionCountTable[Question] + 1
						end
					end
				end
				
				if QuestionCountTable[Question] >= QuestionUpperLimit then
					table.remove(QuestionsLeft, qi)
					continue
				end
				
				if qi == #QuestionsLeft then
					break
				end
				qi = (qi % #QuestionsLeft) + 1
			end
		end
		
		--[[
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
		--]]
	end

	for i,v in next,QuestionCounts do
		for questionNumber,value in next, v do
			print(questionNumber, value)
		end
	end

	print("total: ", BetterConcat(QuestionCountsRunningTotal, " "))

	print("\n")
	
	for i,v in next,PlayerTable do
		print(i, BetterConcat(v, " "))
	end

	task.wait()
end
