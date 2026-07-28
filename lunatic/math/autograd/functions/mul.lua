local broadcast = require("lunatic.math.broadcast")

local Mul = {}

function Mul.backward(gradient, inputs)

    local a = inputs[1]
    local b = inputs[2]

    local grad_a = gradient:mul(b)
    local grad_b = gradient:mul(a)

    return {
        broadcast.reduce_gradient(
            grad_a,
            a.shape
        ),
        broadcast.reduce_gradient(
            grad_b,
            b.shape
        )
    }
end

return Mul