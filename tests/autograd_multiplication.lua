local Tensor = require("lunatic.math.tensor")

local a = Tensor.new({2}, {1})
local b = Tensor.new({3}, {1})

a:set_requires_grad(true)
b:set_requires_grad(true)

local c = a * b

c:backward()

assert(a.grad:get(1) == 3)
assert(b.grad:get(1) == 2)

print("autograd multiplication tests passed!")