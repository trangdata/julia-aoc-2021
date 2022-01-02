using AdventOfCode

# for day = 1:25
#     setup_files(2021, day; force = false, include_year = true)
# end

read_ex(ex) = split(ex, "\n")

chr2hex(x) = string(parse(Int, x, base = 16), base = 2, pad = 4)

make_mat(input) = make_int(hcat(collect.(input)...))

make_int(s) = parse.(Int, s)

bin2dec(x) = parse(Int, x, base = 2)

sort_vals(counts) = sort(collect(counts), by = x -> x[2])

function where_to_next(dir, i, j, step = 1)
    if dir == "down"
        i += step
    elseif dir == "up"
        i -= step
    elseif dir == "left"
        j -= step
    else
        j += step
    end
    i, j
end

function turn(dir, lr = "left", step = 1)
    dirs = ["up", "right", "down", "left"]
    lr == "right" && return (dirs[mod1(findfirst(==(dir), dirs) + step, 4)])
    dirs[mod1(findfirst(==(dir), dirs) - step, 4)]
end

function negate_dir(dir)
    dir ∈ ["up", "down"] && return(["left", "right"])
    return(["up", "down"])
end

function rotate_flip(m)
    m_collect = [clockwise(m, i) for i = 1:3]
    n = push!(m_collect, m)
    append!(n, flip_vert.(n))
end

function clockwise(m, times)
    finrow = size(m, 1)
    back = finrow:-1:1
    if times == 1
        m = transpose(m)
        return (m[:, back])
    elseif times == 3
        m = transpose(m)
        return (m[back, :])
    elseif times == 2
        return (m[back, back])
    end
    return (m)
end

function move(x, dir)
    dir == "right" && return (x + 1)
    return (x - 1)
end

function neighbors_8((i, j), maxi = 10, maxj = 10)
    # 8 neighbors including diagonal
    lowi = max(1, i - 1)
    highi = min(maxi, i + 1)
    lowj = max(1, j - 1)
    highj = min(maxj, j + 1)
    setdiff([(y, x) for x = lowj:highj for y = lowi:highi], [(i, j)])
end

function neighbors_4((i, j), maxi, maxj)
    # 4 neighbors
    out = [
        (max(1, i - 1), j),
        (i, max(1, j - 1)),
        (i, min(j + 1, maxj)),
        (min(i + 1, maxi), j),
    ]
    setdiff(out, [(i, j)])

end
