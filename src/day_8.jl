
include(".././utils.jl")
input = readlines("data/day_8.txt")

b = getindex.(split.(input, " | "), 2)
s = count(length.(vcat(split.(b, " ")...)) .∈ ([2,3,4,7],))

@show s
##--
ch_with_len(i, dict) = reduce(vcat, Set.(findall(x -> last(x) == i, dict)))

s = 0
for i in input
    as, bs = split.(split(i, " | "), " ")

    dicta = Dict(a => length(a) for a in as)
    reala = Dict(Set(a) => 0 for a in as)
    clen = Dict(i => ch_with_len(i, dicta) for i in 2:7)

    reala[clen[2]] = 1
    reala[clen[4]] = 4
    reala[clen[3]] = 7
    reala[clen[7]] = 8

    # intersect(got6, 2) -  5: notempty => 5
    # 3 - 6: b => 6
    tx = setdiff.((clen[3], ), clen[6])
    my6 = clen[6][length.(tx) .> 0][1]
    reala[my6] = 6

    # 4 - 6: empty => 9
    sixes = setdiff(clen[6], [my6])
    fs = setdiff.((clen[4], ), sixes)
    reala[sixes[length.(fs) .== 0][1]] = 9

    # 2 - 5: empty => 3
    tf = setdiff.((clen[2], ), clen[5])
    my5 = clen[5][length.(tf) .== 0][1]
    reala[my5] = 3

    # intersect(my6, 2) -  5: nonempty => 2
    # intersect(my6, 2) -  5: empty => 5
    fives = setdiff(clen[5], [my5])
    twos = setdiff.((intersect(my6, clen[2]), ), fives)
    reala[fives[length.(twos) .> 0][1]] = 2
    reala[fives[length.(twos) .== 0][1]] = 5

    # 3 - 6: empty => 0: default

    outb = [reala[Set(b)] for b in bs]
    plus = make_int(join(string.(outb)))
    global s += plus
end
@show s
