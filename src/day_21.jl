using AdventOfCode
using Chain
using DataFrames
using Combinatorics: permutations, combinations
using LinearAlgebra: dot, transpose
using Primes: factor
using StatsBase: countmap, rle
using Statistics
using Memoize

include(".././utils.jl")

input = readlines("data/day_21.txt")

##--

ex = "Player 1 starting position: 9
Player 2 starting position: 6"

input = read_ex(ex)

s0, s1 = 0, 0
x = 9
y = 6
i = 0
while true
    x = mod1(x + sum(i+1:i+3), 10)

    s0 += x
    i += 3
    if s0 >= 1000
        break
    end

    y = mod1(y + sum(i+1:i+3), 10)
    i += 3
    s1 += y
    if s1 >= 1000
        break
    end
end

@show s0, s1, i
@show min(s0, s1) * (i)



##--
scores = @chain [[1, 2, 3]] begin
    repeat(3)
    Base.product(_...)
    vcat(_...)
    collect.()
    sum.()
    countmap
end

# find number of universes each player wins
# right before the first player moves
# distance between the player's positions and the goal

@memoize function endgame(pos1, pos2, dist1, dist2)
    dist2 <= 0 && return (0, 1) # player 2 wins in 1 universe

    win1, win2 = 0, 0
    for (score, freq) in scores
        # player 1 rolled `score`, update pos1, dist1
        # now player 2 ready to move
        new_pos1 = mod1(pos1 + score, 10)
        new_dist1 = dist1 - new_pos1
        new_w2, new_w1 = endgame(pos2, new_pos1, dist2, new_dist1)
        win1 += freq * new_w1
        win2 += freq * new_w2
    end

    return (win1, win2)

end
out = endgame(9, 6, 21, 21)
@show max(out...)

# Alternatively, consider 2 players separately... (TODO)
