using StatsBase: countmap

include(".././utils.jl")


##--
input = readlines("data/day_14.txt")

# ex = "NNCB
#
# CH -> B
# HH -> N
# CB -> H
# NH -> C
# HB -> C
# HC -> B
# HN -> C
# NN -> C
# BH -> H
# NC -> B
# NB -> B
# BN -> B
# BB -> N
# BC -> B
# CC -> N
# CN -> C"
# input = split(ex, "\n")

temp = input[1]
inst = split.(input[3:end], " -> ")
pair_dict = Dict(i => 0 for i in getindex.(inst, 1))
[pair_dict[temp[i-1:i]] += 1 for i = 2:length(temp)]

for _ = 1:10 # 40 for part 2
    old_dict = copy(pair_dict)

    for (pair, val) in old_dict
        add_let = filter(x -> x[1] == pair, inst)[1][2][1]
        pair1 = pair[1] * add_let
        pair2 = add_let * pair[2]
        pair_dict[pair1] += val
        pair_dict[pair2] += val
        pair_dict[pair] -= val
    end
end

lets = unique(collect(join(getindex.(inst, 1))))
countlet = Dict(i => 0 for i in lets)

for (x, y) in pair_dict
    [countlet[i[1]] += y for i in split(x, "")]
end
countlet[temp[1]] += 1
countlet[temp[end]] += 1
outcount = sort(collect(countlet), by = x -> x[2])
@show (outcount[end][2] - outcount[1][2]) ÷ 2
