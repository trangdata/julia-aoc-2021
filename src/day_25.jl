using Chain

include(".././utils.jl")
input = readlines("data/day_25.txt")

##--

ex = "v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>"

input = read_ex(ex)

inp = @chain input begin
    collect.()
    hcat(_...)
    replace(x -> x == '>' ? '2' : (x == 'v' ? '1' : '0'), _)
    make_int
    transpose
end

ni, nj = size(inp)
counter = 0

while true
    global counter +=1
    east_idx = findall(inp .== 2)
    old_east = []
    new_east = []
    for idx in east_idx
        newi = idx[1]
        newj = mod1(idx[2] + 1, nj)
        if inp[newi, newj] == 0 # open
            push!(old_east, idx)
            push!(new_east, (newi, newj))
        end
    end

    [inp[i] = 0 for i in old_east]
    [inp[i...] = 2 for i in new_east]

    # south facing
    south_idx = findall(inp .== 1)
    old_south = []
    new_south = []
    for idx in south_idx
        newi = mod1(idx[1] + 1, ni)
        newj = idx[2]
        if inp[newi, newj] == 0 # open
            push!(old_south, idx)
            push!(new_south, (newi, newj))
        end
    end

    [inp[i] = 0 for i in old_south]
    [inp[i...] = 1 for i in new_south]

    length(new_south) == 0 && length(new_east) == 0 && break
end

@show counter
