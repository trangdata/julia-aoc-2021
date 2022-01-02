
include(".././utils.jl")

##--
get_val(b) =
    try
        registers[b]
    catch
        make_int(b)
    end

input_ori = readlines("data/day_24.txt")

registers = Dict(string(i) => 0 for i = 'w':'z')
input = split.(input_ori, " ")

# solved by hand
# code for checking

ins = 99893999291967 # part 1
# ins = 34171911181211 # part 2

my_ins = digits(ins)
for my_in in my_ins
    for k = 1:length(input)
        inp = input[k]
        inp[1] == "inp" && (my_in = pop!(my_ins); registers[inp[2]] = my_in)
        inp[1] == "add" && (registers[inp[2]] = registers[inp[2]] + get_val(inp[3]))
        inp[1] == "mul" && (registers[inp[2]] = registers[inp[2]] * get_val(inp[3]))
        inp[1] == "div" && (registers[inp[2]] = registers[inp[2]] ÷ get_val(inp[3]))
        inp[1] == "mod" && (registers[inp[2]] = registers[inp[2]] % get_val(inp[3]))
        inp[1] == "eql" &&
            (registers[inp[2]] = Int(registers[inp[2]] == get_val(inp[3])))

        if k % 18 == 0
            @show k ÷ 18, my_in, registers["z"], registers["x"]
        end
    end
end

##
