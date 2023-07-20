--[[
  Lua stuff based off https://www.lua.org/pil/7.3.html
--]]

local function StatefulNumericIterator(t)
	local n = #t 
	local i = 0
	
	return function()
		i += 1 
		if i <= n then
			return i, t[i]
		end
	end
end

local function StatelessIter(t,i)
	i += 1 
	
	if i <= #t then
		return i, t[i]
	end
end

local function StatelessNumericIterator(t)
	return StatelessIter, t, 0 -- exp returns func, invariant state, control variable
end

--[[
	The for loop must have the three things in its expression list.
	If it only gives a function, then it will expect the iterator function to be stateful (given one).
--]]

local function For(Block, Iterator, InvariantState, ControlVariable)
	while true do
		local Value
		ControlVariable, Value = Iterator(InvariantState, ControlVariable)
		
		if ControlVariable then
			Block(ControlVariable, Value)
		else 
			break
		end
	end
end

local function StatefulFor(Block, Iterator)
	while true do
		local Index, Value = Iterator()
		if Index then 
			Block(Index, Value)
		else
			break
		end
	end
end

local function GenericFor(Block, Iterator, InvariantState, ControlVariable)
	if not (Block and Iterator) then error("Generic For cancelled",2) return end
	
	if InvariantState then -- stateless
		return For(Block, Iterator, InvariantState, ControlVariable) 
	else --stateful
		return StatefulFor(Block, Iterator)
	end
end

For(function(i,v)
	print("Stateless:",i,v)
end, StatelessNumericIterator{1,2,3})

GenericFor(function(i,v) 
	print("generic for: ",i,v)
end, pairs{
	["Ed"] = "Hello";
	["Flav"] = "Bye";
})

GenericFor(function(i,v) 
	print("generic for: ",i,v)
end, next, {
	["Ed"] = "Hello";
	["Flav"] = "Bye";
})

GenericFor(function(i,v)
	print("Stateless generic: ", i, v)
end, StatefulNumericIterator({1,2,3}))
