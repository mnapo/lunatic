local Tensor = require("lunatic.math.tensor")


local x = Tensor.new(
    {1,2,3},
    {3}
)

x:set_requires_grad(true)

local y = x:sum()

assert(y:get(1) == 6)
assert(y.requires_grad == true)
assert(y.grad_fn ~= nil)

y:backward()

assert(x.grad:get(1) == 1)
assert(x.grad:get(2) == 1)
assert(x.grad:get(3) == 1)

pint("Autograd's sum tests passed!")