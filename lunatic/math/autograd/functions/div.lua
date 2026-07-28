local broadcast = require("lunatic.math.broadcast")

local Div = {}

function Div.backward(gradient, inputs)

    local a = inputs[1]
    local b = inputs[2]

    --
    -- da = gradient / b
    --

    local grad_a = gradient:div(b)

    --
    -- db = -(gradient * a) / (b²)
    --

    local b_squared = b:mul(b)

    local grad_b =
        gradient
            :mul(a)
            :div(b_squared)
            :neg()

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

return Div