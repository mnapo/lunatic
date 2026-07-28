local Tensor = require("lunatic.math.tensor")

--
-- division without broadcasting
--

local a = Tensor.new(
    {4, 8},
    {2}
)

local b = Tensor.new(
    {2, 4},
    {2}
)

a:set_requires_grad(true)
b:set_requires_grad(true)


local y = a / b


assert(y:get(1) == 2)
assert(y:get(2) == 2)


local loss = y:sum()

assert(loss.grad_fn ~= nil)

loss:backward()


-- da = 1 / b

assert(a.grad:get(1) == 0.5)
assert(a.grad:get(2) == 0.25)


-- db = -a / b²

print("b grad:")
print(b.grad:get(1))
print(b.grad:get(2))

assert(b.grad:get(1) == -1)
assert(b.grad:get(2) == -0.5)



--
-- division with broadcasting
--

local c = Tensor.new(
    {2, 4, 8},
    {3}
)

local d = Tensor.new(
    {2},
    {1}
)

c:set_requires_grad(true)
d:set_requires_grad(true)


local z = c / d


assert(z:get(1) == 1)
assert(z:get(2) == 2)
assert(z:get(3) == 4)


local total = z:sum()

assert(total.grad_fn ~= nil)

total:backward()


-- dc = 1 / d

assert(c.grad:get(1) == 0.5)
assert(c.grad:get(2) == 0.5)
assert(c.grad:get(3) == 0.5)


-- dd = sum(-c / d²)

-- -(2/4 + 4/4 + 8/4)
-- = -3.5

assert(d.grad:get(1) == -3.5)


print("all division backwards broadcasting tests passed!")