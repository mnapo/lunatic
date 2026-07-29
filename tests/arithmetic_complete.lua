local Tensor = require("lunatic.math.tensor")


local function approx(a, b)
    return math.abs(a - b) < 1e-10
end


--
-- Add forward + backward
--

do

    local a = Tensor.new(
        {1, 2, 3},
        {3}
    )

    local b = Tensor.new(
        {4, 5, 6},
        {3}
    )


    a:set_requires_grad(true)
    b:set_requires_grad(true)


    local y = (a + b):sum()

    assert(y.grad_fn ~= nil)

    y:backward()


    assert(a.grad:get(1) == 1)
    assert(a.grad:get(2) == 1)
    assert(a.grad:get(3) == 1)


    assert(b.grad:get(1) == 1)
    assert(b.grad:get(2) == 1)
    assert(b.grad:get(3) == 1)

end



--
-- Sub forward + backward
--

do

    local a = Tensor.new(
        {5, 7},
        {2}
    )

    local b = Tensor.new(
        {2, 3},
        {2}
    )


    a:set_requires_grad(true)
    b:set_requires_grad(true)


    local y = (a - b):sum()

    y:backward()


    assert(a.grad:get(1) == 1)
    assert(a.grad:get(2) == 1)


    assert(b.grad:get(1) == -1)
    assert(b.grad:get(2) == -1)

end



--
-- Mul backward
--

do

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

    y:backward()


    assert(a.grad:get(1) == 4)
    assert(a.grad:get(2) == 5)


    assert(b.grad:get(1) == 2)
    assert(b.grad:get(2) == 3)

end



--
-- Div backward
--

do

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


    local y = (a / b):sum()

    y:backward()


    assert(approx(a.grad:get(1), 0.5))
    assert(approx(a.grad:get(2), 0.25))


    assert(approx(b.grad:get(1), -1))
    assert(approx(b.grad:get(2), -0.5))

end



--
-- Broadcasting multiplication backward
--

do

    local a = Tensor.new(
        {1, 2, 3},
        {3}
    )

    local b = Tensor.new(
        {10},
        {1}
    )


    a:set_requires_grad(true)
    b:set_requires_grad(true)


    local y = (a * b):sum()

    y:backward()


    assert(a.grad:get(1) == 10)
    assert(a.grad:get(2) == 10)
    assert(a.grad:get(3) == 10)


    assert(b.grad:get(1) == 6)

end



--
-- Broadcasting division backward
--

do

    local a = Tensor.new(
        {2, 4, 8},
        {3}
    )

    local b = Tensor.new(
        {2},
        {1}
    )


    a:set_requires_grad(true)
    b:set_requires_grad(true)


    local y = (a / b):sum()

    y:backward()


    assert(approx(a.grad:get(1), 0.5))
    assert(approx(a.grad:get(2), 0.5))
    assert(approx(a.grad:get(3), 0.5))


    assert(approx(b.grad:get(1), -3.5))

end



--
-- Neg backward
--

do

    local a = Tensor.new(
        {2, -3},
        {2}
    )


    a:set_requires_grad(true)


    local y = (-a):sum()

    y:backward()


    assert(a.grad:get(1) == -1)
    assert(a.grad:get(2) == -1)

end

print("all arithmetic tests passed!")