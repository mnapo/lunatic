local Tensor = require("lunatic.math.tensor")

local x = Tensor.new(
    {2,4,6,8},
    {4}
)

x:set_requires_grad(true)

local y = x:mean()

assert(y:get(1) == 5)

y:backward()

assert(x.grad:get(1) == 0.25)
assert(x.grad:get(2) == 0.25)
assert(x.grad:get(3) == 0.25)
assert(x.grad:get(4) == 0.25)

print("Autograd's mean tests passed!")