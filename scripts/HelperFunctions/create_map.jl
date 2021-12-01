# create map

mapName = "n25h5map.txt"

map = ""
prefix = ""
suffic = ""

open("myfile.txt", "w") do io
    write(io, "Hello world!")
end;

for taxa in 1:25
    map.append(string(prefix, taxa, " ", prefix, taxa))
    map.append(\n)

io = open(mapName, "w");
write(io, Base.string(map));