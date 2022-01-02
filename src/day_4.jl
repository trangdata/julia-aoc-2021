using Chain

input = readlines("data/day_4.txt")
include(".././utils.jl")
inp = make_int(split(input[1], ","))

seti = 0:99
board_idx(i) = 3+6*i:7+6*i
boards = Dict(
    i => @chain input[board_idx(i)] begin
        split.(" ")
        filter.(x -> x != "", _)
        hcat(_...)
        make_int()
    end
    for i in seti
)

board_marks = Dict(i => zeros(Int8, 5, 5) for i in seti)

for ncall in inp, i in seti
    idx = findfirst(x -> x == ncall, boards[i])
    isnothing(idx) || (board_marks[i][Tuple(idx)...] = 1)
    bingo =
        any(sum(board_marks[i], dims = 1) .== 5) ||
        any(sum(board_marks[i], dims = 2) .== 5)
    if bingo
        global winning_board, winning_call = i, ncall
        # println("Board $i wins at call = $ncall")
        break
    end
end

out1 = winning_call * sum([
    boards[winning_board][i, j] for
    i = 1:5, j = 1:5 if (board_marks[winning_board][i, j] == 0)
])
@show out1

##--
# part 2

seti = 0:99
board_marks = Dict(i => zeros(Int8, 5, 5) for i in seti)

for ncall in inp, i in seti
    idx = findfirst(x -> x == ncall, boards[i])
    isnothing(idx) || (board_marks[i][Tuple(idx)...] = 1)
    bingo =
        any(sum(board_marks[i], dims = 1) .== 5) ||
        any(sum(board_marks[i], dims = 2) .== 5)
    if bingo
        global seti = setdiff(seti, i) # remove winning board each time
        global winning_board, winning_call = i, ncall
        # println("Board $i wins at call = $ncall")
        # no break
    end
end

out2 = winning_call * sum([
    boards[winning_board][i, j] for
    i = 1:5, j = 1:5 if (board_marks[winning_board][i, j] == 0)
])

@show out2
