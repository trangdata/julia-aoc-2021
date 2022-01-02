using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics

include(".././utils.jl")

##--
input = readlines("data/day_16.txt")[1]

# make_dec(x) = parse(Int, x, base = 2)

chr2hex(x) = string(parse(Int, x, base = 16), base = 2, pad = 4)

function packet_val(type_id, vals)
    type_id == 0 && return (sum(vals))
    type_id == 1 && return (prod(vals))
    type_id == 2 && return (minimum(vals))
    type_id == 3 && return (maximum(vals))
    type_id == 5 && return Int(vals[1] > vals[2])
    type_id == 6 && return Int(vals[1] < vals[2])
    type_id == 7 && return Int(vals[1] == vals[2])
end

function type4(ex, i)
    num = []
    while i <= length(ex)
        push!(num, ex[i+1:i+4])
        ex[i] == '1' ? i += 5 : break
    end
    (bin2dec(join(num)), i + 5) # start of a new packet
end

# why doesn't recursive work when I tried to specify the argument name???

function get_packet(ex, startp = 1)
    version = bin2dec(ex[startp:startp+2])
    type_id = bin2dec(ex[startp+3:startp+5])
    push!(versions, version)

    type_id == 4 && return (type4(ex, startp + 6))

    len_type_id = ex[startp+6]
    if len_type_id == '0'
        len_subpackets = bin2dec(ex[startp+7:startp+21])
        start_new = startp + 22
        end_new = start_new + len_subpackets - 1
        vals = []
        while start_new < end_new
            (num, start_new) = get_packet(ex, start_new)
            push!(vals, num)
        end
        return (packet_val(type_id, vals), start_new)

    end
    num_subpackets = bin2dec(ex[startp+7:startp+17])
    start_new = startp + 18
    vals = []
    for num_pack = 1:num_subpackets
        (num, start_new) = get_packet(ex, start_new)
        push!(vals, num)
    end
    return (packet_val(type_id, vals), start_new)
end

##--

ex = join([chr2hex(ch) for ch in input])
versions = []
@show get_packet(ex, 1)
@show sum(versions)


##--
