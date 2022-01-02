using AdventOfCode
using Combinatorics: permutations, combinations
using StatsBase: countmap

include(".././utils.jl")

input = readlines("data/day_19.txt")
##--

matrify(x, s) = transpose(hcat(vcat(repeat([x], s))...))
get_beacons(m) = [m[i, :] for i = 1:size(m)[1]]
manhattan(x, y) = sum(abs.(x - y))

function get_beacon_mat(input, from, to)
    @chain input[from:to] begin
        split.(",")
        make_mat
        transpose
    end
end

# array of 3-length arrays with all combinations of 1 and -1
posneg = @chain [[-1, 1]] begin
    repeat(3)
    Base.product(_...)
    vcat(_...)
    collect.()
end

breaks = findall(x -> x == "", input)
n_scanners = length(breaks)
push!(breaks, length(input) + 1)
scanner0 = get_beacon_mat(input, 2, breaks[1] - 1)
united_beacons = get_beacons(scanner0)

mutated_mss = []

for i = 1:n_scanners
    m = get_beacon_mat(input, breaks[i] + 2, breaks[i+1] - 1)
    m_permuted = [m[:, i] for i in permutations(1:3)]
    mutates = [matrify(i, size(m)[1]) for i in posneg]
    mutated_ms = [i .* j for i in m_permuted for j in mutates]
    push!(mutated_mss, mutated_ms)
end

remainning_scanners = 1:n_scanners
m_positions = []
counter = 1

while length(remainning_scanners) > 0
    global counter = mod1(counter, length(remainning_scanners))
    i = remainning_scanners[counter]
    @show i
    for mutated_m in mutated_mss[i]
        n = size(mutated_m)[1]
        diffi = [
            united_beacons[k] .- mutated_m[j, :] for
            k = 1:length(united_beacons) for j = 1:n
        ]
        count_diff = collect(countmap(get_beacons(diffi)))
        beacons12 = findfirst(x -> x[2] >= 12, count_diff)

        if !isnothing(beacons12)
            m_pos = count_diff[beacons12][1][1]
            beacons_mat = mutated_m .+ matrify(m_pos, n)
            global united_beacons = union(united_beacons, get_beacons(beacons_mat))
            global remainning_scanners = setdiff(remainning_scanners, i)
            push!(m_positions, m_pos)

            break
        end
    end
    counter += 1
end

@show length(united_beacons)

##--
# part 2

@show maximum([manhattan(x...) for x in combinations(m_positions, 2)])
