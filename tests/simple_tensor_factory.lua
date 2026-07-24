local Tensor = require("lunatic.math.tensor")
local TensorFactory = require("lunatic.math.internal.tensor_factory")

local t = TensorFactory.create(
    {1,2,3},
    {3}
)

assert(t:get(1) == 1)
assert(t.shape[1] == 3)

print("Simple tensor factory tests passed!")