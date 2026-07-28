local Tensor = require("lunatic.math.tensor")
local reduction = require("lunatic.math.ops.reduction")


local x = Tensor.new(
    {1,2,3,4,5,6},
    {2,3}
)


local a = reduction.sum_axis(
    x,
    1,
    true
)

assert(a.shape[1] == 1)
assert(a.shape[2] == 3)

assert(a:get(1,1) == 5)
assert(a:get(1,2) == 7)
assert(a:get(1,3) == 9)



local b = reduction.sum_axis(
    x,
    2,
    true
)

assert(b.shape[1] == 2)
assert(b.shape[2] == 1)

assert(b:get(1,1) == 6)
assert(b:get(2,1) == 15)

local c = reduction.sum_axis(
    x,
    1,
    false
)

assert(c.shape[1] == 3)

assert(c:get(1) == 5)
assert(c:get(2) == 7)
assert(c:get(3) == 9)

print("all reduction's sum_axis tests passed!")