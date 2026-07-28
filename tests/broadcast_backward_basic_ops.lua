local Tensor = require("lunatic.math.tensor")

local a = Tensor.new(
    {1,2,3},
    {3}
)

local b = Tensor.new(
    {10},
    {1}
)

a:set_requires_grad(true)
b:set_requires_grad(true)

local c = a + b

local y = c:sum()

y:backward()

print("all backwards broadcasting tests passed!")