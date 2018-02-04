-- test add, del and all
local stuff = {}
for i = 1, 3 do
	add(stuff, {name = "hans"..i})
end
for item in all(stuff) do
	print(item.name)
	if rnd() < 0.5 then del(stuff, item) end
end
print("---")
for item in all(stuff) do
	print(item.name)
end