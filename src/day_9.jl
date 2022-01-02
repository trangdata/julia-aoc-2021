using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")
input = readlines("data/day_9.txt")

# ex = "2199943210
#      3987894921
#      9856789892
#      8767896789
#      9899965678"
# input = split(ex, "\n")
inp = transpose(parse.(Int, hcat(collect.(input)...)))

maxi, maxj = length(input), length(input[1])
k = 1

function neighbors(i, j)
    out = [
        (max(1, i - 1), j),
        (i, max(1, j - 1)),
        (i, min(j + 1, maxj)),
        (min(i + 1, maxi), j),
    ]
    setdiff(out, [(i, j)])

end
nrow, ncol = size(inp)
s = []
for i = 1:nrow, j = 1:ncol
    if all([inp[i, j] < inp[x, y] for (x, y) in neighbors(i, j)])
        push!(s, inp[i, j])
    end
end
sum(s .+ 1)
##--

# ex = "2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678"
# #
# input = split(ex, "\n")

input = readlines("data/day_9.txt")
inp = transpose(parse.(Int, hcat(collect.(input)...)))

maxi, maxj = length(input), length(input[1])


adict = Dict((1, 1) => [1])
nrow, ncol = size(inp)
i = 1
j = 2
maxbas = 1


for i = 1:nrow, j = 1:ncol
    i == 1 && j == 1 && continue
    inp[i,j] == 9 && continue

    all_neighs = [(x, y) => inp[x, y] for (x, y) in neighbors(i, j)]
    basin_neighs = getindex.(filter(x -> last(x) != 9, all_neighs), 1)
    if length(basin_neighs) > 0
        checkkeys = [haskey(adict, (x, y)) for (x, y) in basin_neighs]
        if any(checkkeys)
            base_i = basin_neighs[checkkeys]
            combined = sort(unique(vcat(union([adict[bas] for bas in base_i])...)))
            adict[(i,j)] = combined

            reset_idx = collect(keys(filter(x-> any(x[2] .∈ (combined,)), adict)))
            for (x, y) in reset_idx
                adict[(x, y)] = combined
            end

        else
            maxbas += 1
            adict[(i, j)] = [maxbas]
            [adict[(x, y)] = [maxbas] for (x, y) in basin_neighs]
        end
    else
        maxbas += 1
        adict[(i, j)] = maxbas
    end
end
adict


s = countmap(values(adict) |> collect )
w = sort(collect(s), by = x->-x[2])
@show prod(getindex.(w[1:3], 2))

# 1038240 is correct
