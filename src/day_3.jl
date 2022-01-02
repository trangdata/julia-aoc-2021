using StatsBase: countmap

# part 1
input = readlines("data/day_3.txt")

function small2large(input, i)
    check = [k[i] for k in input]
    counts = collect(countmap(check))
    check, sort(counts, by = x -> (x[2], x[1]))
end

bin2dec(x) = parse(Int, x, base = 2)

nbit = length(input[1])
mykeys = []
for i = 1:nbit
    to_app = small2large(input, i)[2][2][1]
    append!(mykeys, to_app)
end

a = bin2dec(*(mykeys...))
@show a * (2^nbit - 1 - a)

##--
# part 2

o2, co2 = input, input

for i = 1:nbit
    check, to_app = small2large(o2, i)
    o2 = o2[check.==to_app[2][1]]
    length(o2) == 1 && break
end

for i = 1:nbit
    check, to_app = small2large(co2, i)
    co2 = co2[check.==to_app[1][1]]
    length(co2) == 1 && break
end

@show bin2dec(o2[1]) * bin2dec(co2[1])
