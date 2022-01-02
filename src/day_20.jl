
include(".././utils.jl")

input = readlines("data/day_20.txt")
##--

ex = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"
input = read_ex(ex)

##--
algo = input[1]
img = input[3:end]

img_dict = Dict(
    (j, i) => Int(img[i][j] == '#') for i = 1:length(img) for
    j = 1:length(img[1])
)

function get_val(x, img_dict, k, alt)
    haskey(img_dict, x) && return (img_dict[x])
    alt && return (Int(mod(k, 2) == 0)) # particular to my algorithm, 0 works for example
    0
end

neighbors_9(i, j) = [(y, x) for x = j-1:j+1 for y = i-1:i+1]

alt = algo[1] == '#' && algo[512] == '.'
imin, imax = 0, length(img[1]) + 1
jmin, jmax = 0, length(img) + 1
new_img_dict = copy(img_dict)

for k = 1:50 # 2 for part 1
    print(k)
    for i = imin:imax, j = jmin:jmax
        idx =
            [get_val(x, img_dict, k, alt) for x in neighbors_9(i, j)] |>
            join |>
            bin2dec
        new_img_dict[(i, j)] = Int(algo[idx+1] == '#')
    end
    global img_dict = copy(new_img_dict)
    global imin -= 1
    global jmin -= 1
    global imax += 1
    global jmax += 1
end

@show sum(values(img_dict))
