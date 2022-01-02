using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")



ex = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
135(size_mat-1)12421
3125421639
1293138521
2311944581"
input = read_ex(ex)


##--

input = readlines("data/day_15.txt")
inp = make_int(hcat(collect.(input)...))
size_mat = size(inp)[1]

# function lowest_risk(i, j)
#     (i == size_mat && j == size_mat) && return (inp[i, j])
#     i == size_mat && return (inp[i, j] + lowest_risk(i, j + 1))
#     j == size_mat && return (inp[i, j] + lowest_risk(i + 1, j))
#
#     return (inp[i, j] + min(lowest_risk(i + 1, j), lowest_risk(i, j + 1)))
# end
# res = lowest_risk(1, 1)
# @show res - inp[1, 1]


##--

function neighbors_4((i, j), maxi = size_mat, maxj = size_mat)
    # 4 neighbors
    out = [
        (max(1, i - 1), j),
        (i, max(1, j - 1)),
        (i, min(j + 1, maxj)),
        (min(i + 1, maxi), j),
    ]
    setdiff(out, [(i, j)])

end




##--
#
input = readlines("data/day_15.txt")
inp = make_mat(input)

# inp2 = hcat([vcat([append_input(num) for num = x:(x+4)]...) for x = 0:4]...)
# inp2 = @chain append_input begin
#     map(x -> map(_, x:(x+4)), 0:4)
#     vcat.(_...)
#     hcat(_...)
# end

append_input(x) = mod1.(inp .+ x, 9)
inp2 = @chain append_input begin
    map.([i:i+4 for i = 0:4])
    vcat.(_...)
    hcat(_...)
end


inp = copy(inp2)
lower_dict = Dict()
size_mat = size(inp)[1]

for i = size_mat:-1:1, j = size_mat:-1:1
    i == j == size_mat && (lower_dict[(i, j)] = inp[i, j]; continue)
    lowi = try lower_dict[(i + 1, j)] catch; Inf end
    lowj = try lower_dict[(i, j + 1)] catch; Inf end

    lower_dict[(i, j)] = inp[i, j] + min(lowi, lowj)
end


current_lowest = lower_dict[(1, 1)] + 1
new_lowest = current_lowest - 1

while current_lowest != new_lowest
    current_lowest = new_lowest
    for j = size_mat-1:-1:1, i = size_mat-1:-1:1
        min_neighbors = minimum([lower_dict[(x, y)] for (x, y) in neighbors_4((i, j))])
        lower_dict[(i, j)] = min(lower_dict[(i, j)], inp[i, j] + min_neighbors)
    end
    new_lowest = lower_dict[(1,1)]
end

@show Int(new_lowest) - inp[1, 1]
# 462; 2846
