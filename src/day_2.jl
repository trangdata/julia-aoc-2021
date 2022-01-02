
input = readlines("data/day_2.txt")

x, d = 0, 0
for i in input
    inp = split(i, " ")
    dir, num = inp[1], parse(Int, inp[2])
    dir == "forward" && (x += num)
    dir == "up" && (d -= num)
    dir == "down" && (d += num)
end
@show x * d

x, d, aim = 0, 0, 0
for i in input
    inp = split(i, " ")
    dir, num = inp[1], parse(Int, inp[2])
    dir == "forward" && (x += num; d += aim * num)
    dir == "up" && (aim -= num)
    dir == "down" && (aim += num)
end
@show x * d
