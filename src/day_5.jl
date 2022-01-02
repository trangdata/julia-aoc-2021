using StatsBase: countmap, rle

include(".././utils.jl")

input = readlines("data/day_5.txt")

function vents(line, diag = false)
    (sx, sy), (ex, ey) = line
    diffx = sign(ex - sx)
    diffy = sign(ey - sy)
    diffx == diffy == 0 && return (Tuple(startp))
    diffx == 0 && return ([(sx, k) for k = sy:diffy:ey])
    diffy == 0 && return ([(k, sy) for k = sx:diffx:ex])
    diag && return (zip(sx:diffx:ex, sy:diffy:ey))

    return ([])
end

my_vents = []
my_vents_diag = []
for i in input
    line = [make_int(i) for i in split.(split(i, " -> "), ",")]
    append!(my_vents, vents(line, false))
    append!(my_vents_diag, vents(line, true))

end

ans_1 = filter(x -> x[2] > 1, collect(countmap(my_vents))) |> length
ans_2 = filter(x -> x[2] > 1, collect(countmap(my_vents_diag))) |> length

@show ans_1
@show ans_2
