local Tensor = require("lunatic.math.tensor")

--
-- multiplication without broadcasting
--

local a = Tensor.new(
    {2, 3},
    {2}
)

local b = Tensor.new(
    {4, 5},
    {2}
)

a:set_requires_grad(true)
b:set_requires_grad(true)


local y = (a * b):sum()

print("mul graph:", y.grad_fn ~= nil)

y:backward()


assert(a.grad:get(1) == 4)
assert(a.grad:get(2) == 5)

assert(b.grad:get(1) == 2)
assert(b.grad:get(2) == 3)


--
-- multiplication with broadcasting
--

local c = Tensor.new(
    {1, 2, 3},
    {3}
)

local d = Tensor.new(
    {10},
    {1}
)

c:set_requires_grad(true)
d:set_requires_grad(true)


local z = (c * d):sum()

print("broadcast mul graph:", z.grad_fn ~= nil)

z:backward()


-- dc = d
assert(c.grad:get(1) == 10)
assert(c.grad:get(2) == 10)
assert(c.grad:get(3) == 10)


-- dd = sum(c)
assert(d.grad:get(1) == 6)


print("all multiplication backwards broadcasting tests passed!")