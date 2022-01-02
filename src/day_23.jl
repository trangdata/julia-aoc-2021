using AdventOfCode
using Chain
using DataFrames, DataFramesMeta
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")

input = readlines("data/day_22.txt")


##--
ex = "#############
#...........#
###A#D#B#C###
  #B#C#D#A#
  #########"
input = read_ex(ex)
"#############
#...........#
###D#D#C#C###
  #B#A#B#A#
  #########"

##--
amps = collect('A':'D')
energies = Dict('A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000)
hallway = collect(1:7)
rooms = Dict(
    'A' => collect(8:11),
    'B' => collect(12:15),
    'C' => collect(16:19),
    'D' => collect(20:23),
)

rooms_indices = vcat(values(rooms)...)
edges = Dict(
    (1, 2) => 1,
    (2, 3) => 2,
    (3, 4) => 2,
    (4, 5) => 2,
    (5, 6) => 2,
    (6, 7) => 1,
    (8, 9) => 1,
    (9, 10) => 1,
    (10, 11) => 1,
    (12, 13) => 1,
    (13, 14) => 1,
    (14, 15) => 1,
    (16, 17) => 1,
    (17, 18) => 1,
    (18, 19) => 1,
    (20, 21) => 1,
    (21, 22) => 1,
    (22, 23) => 1,
    (2, 8) => 2,
    (8, 3) => 2,
    (3, 12) => 2,
    (12, 4) => 2,
    (4, 16) => 2,
    (16, 5) => 2,
    (5, 20) => 2,
    (20, 6) => 2,
)

accessibles = Dict(i => vcat(hallway, rooms[i]) for i in amps)
connections = Dict(
    from => vcat(setdiff.(filter(x -> from in x, keys(edges)), from)...) for
    from = 1:23
)
rev_edges = Dict((j, i) => edges[i, j] for (i, j) in keys(edges))
all_edges = merge(edges, rev_edges)

function to_hallway(i,j)
    tops = to_top(i)
    top = tops[end]
    cons = intersect(connections[top], hallway)
    all(cons .< j) && return(append!(tops, collect(maximum(cons):j)))
    all(cons .> j) && return(append!(tops, collect(minimum(cons):-1:j)))
    push!(tops, j)
end

function to_top(i)
    i<12 && return(collect(i:-1:8))
    i<16 && return(collect(i:-1:12))
    i<20 && return(collect(i:-1:16))
    collect(i:-1:20)
end

function path_length(p)
    sum([all_edges[p[i-1], p[i]] for i = 2:length(p)])
end

clear_path(burrow, path) = all(isnothing.(getindex.((burrow,), path)))

endgame = Array{Union{Nothing,Char}}(nothing, 23)
[[endgame[i[2][k]] = i[1] for k = 1:4] for i in rooms]
endgame
endgames = []

burrow = Array{Union{Nothing,Char}}(nothing, 23)
[burrow[i] = 'A' for i in [8, 18, 21, 23]]
[burrow[i] = 'B' for i in [11, 14, 16, 17]]
[burrow[i] = 'C' for i in [13, 15, 20, 22]]
[burrow[i] = 'D' for i in [9, 10, 12, 19]]

states = Dict(burrow=>0)

function add_state(burrow, score, amp, from, to, path, states)
    # amp = burrow[from]
    new_burrow = deepcopy(burrow)
    new_burrow[to] = amp
    new_burrow[from] = nothing
    new_score = score + energies[amp]*path_length(path)
    new_burrow == endgame && push!(endgames, new_score)

    if haskey(states, new_burrow)
        states[new_burrow] = min(states[new_burrow], new_score)
    else
        states[new_burrow] = new_score
    end

    states
end

# for burrow in keys(states)
#     score = states[state]
# unoccupied = findall(isnothing, burrow)
# burrow = new_burrow
##--
# burrow = collect(keys(states))[3]
# collect(states)[end]
# burrow = ['B', 'A', 'C', 'D', 'C', 'D', 'B', 'A', 'D', 'D', 'B', nothing, nothing, nothing, 'B', nothing, nothing, nothing, 'C', nothing, 'A', 'C', 'A']
for burrow in keys(states)
    score = states[burrow]
    froms = findall(!isnothing, burrow)
    for from in froms
        amp = burrow[from]
        if from in rooms_indices
            # stay put if already in the right room
            # and if everything below is in the right room
            if from ∈ rooms[amp] && all(getindex(burrow, filter(>=(from), rooms[amp])) .== amp)
                continue
            end
            for to in hallway
                path = to_hallway(from, to)
                clear_path(burrow, path[2:end]) || (continue)

                states = add_state(burrow, score, amp, from, to, path, states)
            end
        else # need to go to room now
            tos = rooms[amp]
            path = to_hallway(maximum(tos), from)
            clear_path(burrow, path[4:end-1]) || (continue)

            current_occupants = getindex.((burrow,), tos)
            no_occu = isnothing.(current_occupants)
            if all(no_occu)
                to = maximum(tos)
                states = add_state(burrow, score, amp, from, to, path, states)
            elseif any(setdiff(current_occupants, [nothing]) .≠ amp)
                continue
            else
                 n_occupants = count(.~no_occu)
                 to = maximum(tos) - n_occupants
                 path = to_hallway(to, from)
                 states = add_state(burrow, score, amp, from, to, path, states)
            end
        end
    end
end
@show length(states)
@show endgames

maximum(values(states))
out = filter(x -> 50000>x[2] > 40000, states)


##--




for _ = 1:200
    for state in keys(states)
        score = states[state]
        occupied = vcat(values(state)...)

        for amp in amps
            state[amp] == rooms[amp] && continue
            for k = 1:2
                from = state[amp][k]
                from == rooms[amp][4] && (continue)
                # if from == rooms[amp][1] && rooms[amp][2] ∉ occupied
                #     to = rooms[amp][2]
                #     new_state = deepcopy(state)
                #     new_state[amp][k] = to
                #     new_state[amp] = sort(new_state[amp])
                #     new_score = score + energies[amp] * all_edges[[from, to]...]
                #     new_state == endgame && push!(endgames, new_score)
                #     new_occupied = vcat(values(state)...)
                #     # if length(unique(new_occupied)) < length(new_occupied)
                #     #     @show state, amp, new_state, occupied
                #     # end
                #
                #     if haskey(states, new_state)
                #         states[new_state] = min(states[new_state], new_score)
                #     else
                #         states[new_state] = new_score
                #     end
                #     break
                # end

                tos = intersect(connections[from], accessibles[amp])

                from == 4 && push!(tos, 3)
                from == 7 && push!(tos, 6)
                from == 10 && push!(tos, 9)
                from == 13 && push!(tos, 12)

                from == 16 && append!(tos, [4])
                from == 18 && append!(tos, [7])
                from == 20 && append!(tos, [10])
                from == 22 && append!(tos, [13])

                from == 17 && append!(tos, [16])
                from == 19 && append!(tos, [18])
                from == 21 && append!(tos, [20])
                from == 23 && append!(tos, [22])


                tos = setdiff(tos, occupied)
                # [from == i && push!(tos, i-1) for i = 4:3:13]

                for to in tos
                    if to == rooms[amp][1]
                        amp_leaf = findfirst(
                            x ->
                                rooms[amp][2] in x ||
                                    rooms[amp][3] in x ||
                                    rooms[amp][4] in x,
                            state,
                        )
                        if !isnothing(amp_leaf) && amp_leaf != amp
                            continue
                        end
                    end
                    new_state = deepcopy(state)
                    new_state[amp][k] = to
                    new_state[amp] = sort(new_state[amp])
                    new_score = score + energies[amp] * all_edges[[from, to]...]
                    new_state == endgame && push!(endgames, new_score)
                    if haskey(states, new_state)
                        states[new_state] = min(states[new_state], new_score)
                    else
                        states[new_state] = new_score
                    end
                end
            end
        end
    end


    @show length(states)
    @show endgames
    @show maximum(values(states))

end
unique(keys(states))
out = filter(x -> 13338 > last(x) > 13335, states)
check = collect(keys(states))[1:5]


##--




connections[3]





##--
endgame = Array{Union{Nothing,Char}}(nothing, 15)
[[endgame[i[2][k]] = i[1] for k = 1:2] for i in rooms]
endgame
endgame_scores = []

ori_nodes = Array{Union{Nothing,Char}}(nothing, 15)
ori_nodes[3] = 'A'
ori_nodes[4] = 'B'
ori_nodes[6] = 'D'
ori_nodes[7] = 'C'
ori_nodes[9] = 'B'
ori_nodes[10] = 'D'
ori_nodes[12] = 'C'
ori_nodes[13] = 'A'

states = DataFrame(nodes = [ori_nodes], score = 0)
states = @combine(groupby(states, :nodes), :score = minimum(:score))

counter = 0
while counter < nrow(states)
    counter += 1
    new_state = states[counter, :]
    score = new_state[2]
    if new_state[1] == endgame
        push!(endgame_scores, new_state)
        continue
    end
    nodes = deepcopy(new_state[1])
    occupied = findall(!isnothing, nodes)

    next_state = nothing
    for amphi in keys(rooms)
        from = rooms[amphi][1]
        to = rooms[amphi][2]
        if nodes[from] == amphi && isnothing(nodes[to])
            nodes[to] = amphi
            nodes[from] = nothing
            score += energies[amphi] * edges[sort(rooms[amphi])...]
            next_state = (nodes, score)
            push!(states, next_state)
            @show next_state
            break
            # continue
        end
    end

    if !isnothing(next_state)
        continue
    end

    froms = findall(!isnothing, nodes)
    # from = froms[5]
    for from in froms
        amphi = nodes[from]
        if from == rooms[amphi][2]
            continue
        end

        # connected = vcat(setdiff.(filter(x -> from in x, keys(edges)), from)...)
        connected = connections[from]
        # unoccupied nodes:
        tos = connected[findall(isnothing, getindex.((nodes,), connected))]
        # tos = intersect(
        #     setdiff(connections[from], occupied),
        #     accessibles[amphi],
        # )
        # to = tos[2]
        for to in tos
            # new_score = 0
            if to in rooms_indices && from ∉ rooms_indices
                leaf = nodes[rooms[amphi][2]]
                if to ∉ rooms[amphi] || (!isnothing(leaf) && to ∉ rooms[leaf])
                    continue
                end
            end
            new_nodes = deepcopy(nodes)
            new_nodes[to] = amphi
            new_nodes[from] = nothing
            new_score = score + energies[amphi] * edges[sort([from, to])...]
            push!(states, (new_nodes, new_score))
        end
    end
    states = @combine(groupby(states, :nodes), :score = minimum(:score))

end




##--
#
# x = [2,3,4]
# function addk(k)
#     push!(x, k)
# end
# addk(15)
# x


##--
@show endgame_scores
@show states
length(unique(states[:, 1]))

endgame_scores
endgame2 = states[1, 1]
out = filter(x -> 14000 > x[2] > 12000, states)

filter(x -> x[1:3] == [nothing, nothing, 'A'], out[:, 1])
