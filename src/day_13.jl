using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")


##--
input = readlines("data/day_13.txt")
inp = [make_int(i) for i in split.(input[1:end-13], ",")]
last12 = input[end-11:end]

kept_dots = deepcopy(inp)

function folded(x, y, num, axis)
    axis == 1 && return ([num * 2 - x, y])
    [x, num * 2 - y]
end

# for part 1, use
# for i in [last12[1]]
for i in last12
    fold = split(split(i, " ")[end], "=")
    num = make_int(fold[2])
    axis = Int(fold[1] == "y") + 1

    after = filter(x -> x[axis] > num, kept_dots)
    kept_dots = filter(x -> x[axis] < num, kept_dots)

    for (x, y) in after
        foldi = folded(x, y, num, axis)
        foldi in kept_dots || push!(kept_dots, foldi)
    end
end

maxx = maximum(getindex.(inp, 1))
maxy = maximum(getindex.(inp, 2))
out = Array{Char}(undef, maxy + 1, maxx + 1)
out .= '.'
for (x, y) in kept_dots
    out[y+1, x+1] = '#'
end

for i = 0:7
    display(out[1:6, (i*5+1):(i*5)+4])
end
@show length(kept_dots)

##--
# ex = "6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0
#
# fold along y=7
# fold along x=5"
# input = split(ex, "\n")
#
# inp = [make_int(i) for i in split.(input[1:end - 3], ",")]
# last12 = input[end-1:end]
