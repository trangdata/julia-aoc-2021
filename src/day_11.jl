using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")
input = readlines("data/day_11.txt")

function get_neighbors((i, j))
    lowi = max(1, i - 1)
    highi = min(10, i + 1)
    lowj = max(1, j - 1)
    highj = min(10, j + 1)
    setdiff([(y, x) for x = lowj:highj for y = lowi:highi], [(i, j)])
end

inp0 = transpose(parse.(Int, hcat(collect.(input)...)))
##--
# part 1
inp = copy(inp0)
flashes = 0
for _ = 1:100
    inp .+= 1
    nines = findall(x -> x > 9, inp)

    while length(nines) > 0
        for ind in nines
            for (x, y) in get_neighbors(Tuple(ind))
                0 < inp[x, y] <= 9 && (inp[x, y] += 1)
            end
            inp[ind] = 0
            flashes += 1
        end
        nines = findall(x -> x > 9, inp)
    end
end

@show flashes

##---
# part 2
inp = copy(inp0)

step = 0
while !all(inp .== 0)
    step += 1
    inp .+= 1
    nines = findall(x -> x > 9, inp)

    while length(nines) > 0
        for ind in nines
            for (x, y) in get_neighbors(Tuple(ind))
                0 < inp[x, y] <= 9 && (inp[x, y] += 1)
            end
            inp[ind] = 0
        end
        nines = findall(x -> x > 9, inp)
    end
end

@show step
