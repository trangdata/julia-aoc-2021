using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")
input = readlines("data/day_10.txt")

open_close = Dict('{' => '}', '(' => ')', '[' => ']', '<' => '>')
opens = Set(keys(open_close))
##--
# part 1
penalty_dict = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
penalties = []
for i in input
    queue = []
    for ch in i
        if ch ∈ opens
            push!(queue, ch)
        else
            ch != open_close[queue[end]] && (push!(penalties, ch); break)
            pop!(queue)
        end
    end
end

@show [penalty_dict[corrupt] for corrupt in penalties] |> sum

## part 2
tocompletes = []
points_dict = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

for i in input
    corrupted = false
    queue = []
    for ch in i
        if ch ∈ opens
            push!(queue, ch)
        else
            ch != open_close[queue[end]] && (corrupted = true; break)
            pop!(queue)
        end
    end
    corrupted && continue
    length(queue) == 0 && continue
    push!(tocompletes, reverse([open_close[q] for q in queue]))
end

s = []
for tocomp in tocompletes
    si = 0
    [si = si * 5 + points_dict[ch] for ch in tocomp]
    push!(s, si)
end

@show Int(median(s))
