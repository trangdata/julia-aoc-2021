
##--
# input = readlines("data/day_17.txt")
# target area: x=179..201, y=-109..-63

# part 1
ymin, ymax = -109, -63
true_y = 0
for y = 1000:-1:100
    k = cumsum(y:-1:ymin)
    count(ymin .<= k .<= ymax) == 1 && (true_y = y; break)
end
@show maximum(cumsum(true_y:-1:ymin))



# part 2
xmin, xmax = 179, 201
vx = Int(ceil(sqrt(xmin * 2)))

count_y = 0
for vy = ymin:true_y, vx = vx:xmax
    ys = cumsum(vy:-1:ymin)
    xs = cumsum(vx:-1:0)
    in_range = [
        ymin <= ys[i] <= ymax && xmin <= xs[min(i, length(xs))] <= xmax for
        i = 1:length(ys)
    ]
    count(in_range) >= 1 && (count_y += 1)
end

@show count_y
