
include(".././utils.jl")
input = readlines("data/day_12.txt")

check_lower(x) = all(islowercase.(collect(x)))
check_part1(x) = sum(check_lower.(unique(x))) == sum(check_lower.(x))
check_part2(x) = (sum(check_lower.(x)) - sum(check_lower.(unique(x)))) <= 1

##--
# part 1
inp = split.(input, "-")
paths = 0
all_links = [["start"]]

while length(all_links) > 0
    link = popfirst!(all_links)
    linkedout = filter(x -> link[end] in x, inp)
    ignored_els = [link[end], "start"]
    new_els = setdiff(union(linkedout...), ignored_els)
    linked = vcat.((link,), new_els)
    linked = filter(x -> check_part1(x), linked)

    for i in linked
        i[end] == "end" ? (paths += 1) : push!(all_links, i)
    end
end
@show paths

##--
# part 2
inp = split.(input, "-")
paths = 0
all_links = [["start"]]

while length(all_links) > 0
    link = popfirst!(all_links)
    linkedout = filter(x -> link[end] in x, inp)
    ignored_els = [link[end], "start"]
    new_els = setdiff(union(linkedout...), ignored_els)
    linked = vcat.((link,), new_els)
    linked = filter(x -> check_part2(x), linked)

    for i in linked
        i[end] == "end" ? (paths += 1) : push!(all_links, i)
    end
end
@show paths
