local Broadcast = require("lunatic.math.broadcast")
local Tensor = require("lunatic.math.tensor")


local g1 = Tensor.new(
    {1,1,1},
    {3}
)

local r1 =
    Broadcast.reduce_gradient(
        g1,
        {1}
    )

assert(r1.shape[1] == 1)
assert(r1:get(1) == 3)

local g2 = Tensor.new(
    {
        1,2,3,
        4,5,6
    },
    {2,3}
)

local r2 =
    Broadcast.reduce_gradient(
        g2,
        {1,3}
    )


assert(r2:get(1,1) == 5)
assert(r2:get(1,2) == 7)
assert(r2:get(1,3) == 9)

print("all broadcast's gradient reduction tests passed!")