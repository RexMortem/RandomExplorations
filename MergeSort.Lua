local function PrintTable(t) 
	local TString = ""
	
	for i,v in ipairs(t) do TString = TString .. v .. " " end 
	
	print("table", TString)
end

local function Merge(t, l, m, r)
	local i1 = l 
	local i2 = m 
	
	local temp = {} -- makes it easier to deal with a temporary array to avoid overwrites 
	
	while (i1 < m) and (i2 <= r) do
		if t[i1] > t[i2] then
			table.insert(temp, t[i2])
			i2 = i2 + 1 
		else
			table.insert(temp, t[i1])
			i1 = i1 + 1 
		end
	end
	
	if (i1 < m) then
		for i = i1, m do
			table.insert(temp, t[i])
		end
	end
	
	if (i2 <= r) then
		for i = i2, r do
			table.insert(temp, t[i])
		end
	end
	
	print("pre-load", l ,r, #temp)
	
	for i = l, r do 
		print("loading", i, t[(i + 1) - l])
		t[i] = temp[(i+1) - l] -- loading the temporary results into the array
	end

	PrintTable(t)
end


local function MergeSort(t, l, r)
	l = l or 1
	r = r or #t
	
	local Pointer = math.floor((r + l)/2)
	print("Pointer", Pointer)
	
	if (Pointer == r) or (Pointer == l) then -- smallest divisible
		print("smallest divisible", l, r)
		if t[l] > t[r] then
			t[l], t[r] = t[r], t[l]
			PrintTable(t)
		end
	else
		MergeSort(t, l, Pointer)
		MergeSort(t, Pointer, r)
		Merge(t, l, Pointer, r)
	end
end

--[[
MergeSort(1, 8) : 4 -> MergeSort(1, 4), MergeSort(4, 8); 
	MergeSort(1,4) : 2 -> MergeSort(1, 2), MergeSort(2, 4);
		MergeSort(1, 2) : 1 -> swap
		MergeSort(2, 4) : 3 -> MergeSort(2, 3), MergeSort(3, 4);
			MergeSort(2, 3) : 2 -> swap 
			MergeSort(3, 4) : 3 -> swap
			
			Merge(2, 3, 4)
		
		Merge(1, 2, 4)
	MergeSort(4, 8) : 
--]]
local Table = {38, 27, 43, 3, 9, 82, 10}
MergeSort(Table)

for i,v in ipairs(Table) do 
	print(i, v)
end
