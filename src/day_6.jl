using StatsBase: countmap

input = readlines("data/day_6.txt")

include(".././utils.jl")
# input = ["3,4,3,1,2"]

inp = split(input[1], ",") |> make_int
newday = countmap(inp)
[haskey(newday, i) || (newday[i] = 0) for i = 0:8]
newday2 = copy(newday)
for _ = 1:256
    [newday[mod(i - 1, 9)] = newday2[i] for i = 0:8]
    newday[6] += newday2[0]
    newday2 = copy(newday)
end

@show values(newday) |> sum
