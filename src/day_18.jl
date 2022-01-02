using Combinatorics: combinations
using StatsBase: countmap, rle

include(".././utils.jl")

##-- test data

ex_str = "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]"

input = read_ex(ex_str)

##--

function add_snails(x)
    out = vcat(x...)
    [i[2] += 1 for i in out]
    out
end

function find_depth(ex, i)
    right_counts = try
        countmap(ex[1:i])[']']
    catch
        0
    end
    countmap(ex[1:i])['['] - right_counts
end

to_array(ex) = filter(
    x -> !isnothing(x),
    [
        try
            [make_int(ex[i]), find_depth(ex, i)]
        catch
            nothing
        end for i = 1:length(ex)
    ],
)

function explode(arr)

    while true
        to_explodes = findall(x -> x[2] >= 5, arr)

        if length(to_explodes) > 0
            myrle = rle(getindex.(arr[to_explodes], 2))
            exp_idx = to_explodes[findfirst(x -> x > 1, myrle[2])]

            left, right = arr[exp_idx:exp_idx+1]
            try
                arr[exp_idx-1][1] += left[1]
            catch
                nothing
            end
            try
                arr[exp_idx+2][1] += right[1]
            catch
                nothing
            end
            arr[exp_idx][2] -= 1
            arr[exp_idx][1] = 0

            deleteat!(arr, exp_idx + 1)

        else # split snails >= 10
            to_split = findfirst(x -> x[1] >= 10, arr)
            isnothing(to_split) && break
            arr = vcat(
                arr[1:to_split-1],
                split_10(arr[to_split]),
                arr[to_split+1:end],
            )
        end
    end
    arr
end

function get_mag(arr)
    sum_arr = deepcopy(arr)
    while length(sum_arr) > 1
        deepest = maximum(getindex.(sum_arr, 2))
        to_sum = findall(x -> x[2] == deepest, sum_arr)
        left_indices =
            getindex(to_sum, [i for i = 1:length(to_sum) if i % 2 == 1])

        for left_idx in left_indices
            sum_arr[left_idx][1] =
                3 * sum_arr[left_idx][1] + 2 * sum_arr[left_idx+1][1]
            sum_arr[left_idx][2] -= 1
        end
        deleteat!(sum_arr, left_indices .+ 1)
    end
    sum_arr[1][1]
end

function split_10(x)
    val, depth = x
    first = Int(floor(val / 2))
    [[first, depth + 1], [val - first, depth + 1]]
end

##--
input = readlines("data/day_18.txt")

# part 1
arr = to_array(input[1])
for i = 2:length(input)
    new_arr = to_array(input[i])
    global arr = explode(add_snails([arr, new_arr]))
end
@show get_mag(arr)


##--
# part 2

all_combs = collect(combinations(deepcopy(to_array.(input)), 2))
max_sum = maximum([
    get_mag(explode(add_snails(deepcopy(comb)))) for
    comb in vcat(all_combs, reverse.(all_combs))
])

@show max_sum
