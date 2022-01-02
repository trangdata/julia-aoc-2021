input = readlines("data/day_7.txt")

include(".././utils.jl")

inp = split(input[1], ",") |> make_int
maxa = maximum(inp)
function myc(a, x)
    diff = abs(a - x)
    diff * (diff + 1) ÷ 2
end

@show [sum([abs(a - x) for x in inp]) for a = 0:maxa] |> minimum
@show [sum([myc(a, x) for x in inp]) for a = 0:maxa] |> minimum

##-- alternative method

using Statistics
a = floor(median(inp)) |> Int
@show sum([abs(a - x) for x in inp])
a = floor(mean(inp)) |> Int
@show sum([myc(a, x) for x in inp])
