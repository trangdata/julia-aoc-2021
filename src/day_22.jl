include(".././utils.jl")

function volume(x)
    v, sig = x
    sig * prod(getindex.(v, 2) .- getindex.(v, 1) .+ 1)
end

function find_x_overlap(x, newx)
    minx1, maxx1 = x
    minx2, maxx2 = newx
    if minx1 <= maxx2 && minx2 <= maxx1
        return ([max(minx1, minx2), min(maxx1, maxx2)])
    end
    nothing
end

function find_overlap(cube, new_cube)
    x, y, z = cube
    newx, newy, newz = new_cube
    xlap = find_x_overlap(x, newx)
    isnothing(xlap) && return (nothing)

    ylap = find_x_overlap(y, newy)
    isnothing(ylap) && return (nothing)

    zlap = find_x_overlap(z, newz)
    isnothing(zlap) && return (nothing)
    return (xlap, ylap, zlap)

end

parse_cube(cube) =
    Tuple(make_int.(split.(getindex.(split.(split(cube, ","), "="), 2), "..")))

##--
# part 1
input = readlines("data/day_22.txt")
inp = split.(input, " ")

cube_dict = Dict()
function turn(xyz, action)
    cube_dict[xyz] = Int(action == "on")
end

min_val = -50
max_val = 50

for i in inp
    action, cubei = i
    x, y, z = parse_cube(cubei)

    minx = max(min_val, x[1])
    miny = max(min_val, y[1])
    minz = max(min_val, z[1])

    maxx = min(max_val, x[2])
    maxy = min(max_val, y[2])
    maxz = min(max_val, z[2])

    cubed = Base.product([minx:maxx, miny:maxy, minz:maxz]...)

    for cube in cubed
        turn(cube, action)
    end
end

@show length(filter(x -> x[2] == 1, cube_dict))

##--
# part 2

cube_list = []

for i in inp
    action, cubei = i
    new_cube = parse_cube(cubei)
    new_inters = []
    for cube in cube_list
        new_inter = (find_overlap(cube[1], new_cube), -cube[2])
        push!(new_inters, new_inter)
    end
    append!(cube_list, new_inters)

    action == "on" && push!(cube_list, (new_cube, 1))
    global cube_list = filter(x -> !isnothing(x[1]), cube_list)
end

@show sum(volume.(cube_list))
