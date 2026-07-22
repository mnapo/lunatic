local Tensor = require("lunatic.math.tensor")

local a = Tensor.new({2}, {1})
local b = Tensor.new({3}, {1})
local c = Tensor.new({4}, {1})

a:set_requires_grad(true)
b:set_requires_grad(true)
c:set_requires_grad(true)


local d = a + b
local e = d + c


e:backward()


assert(a.grad:get(1) == 1)
assert(b.grad:get(1) == 1)
assert(c.grad:get(1) == 1)

print("all autograd composition tests passed")