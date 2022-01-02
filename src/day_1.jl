input = readlines("data/day_1.txt")

function part_1(input)
    x = parse.(Int, input)
    sum(diff(x) .> 0)
end
@show part_1(input)

function part_2(input)
    x = parse.(Int, input)
    count([x[i] > x[i-3] for i = 4:length(x)])
end
@show part_2(input)
