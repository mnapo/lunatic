local broadcast = require("lunatic.math.broadcast")

local Sub = {}

function Sub.backward(gradient, inputs)
    return {
        broadcast.reduce_gradient(
            gradient,
            inputs[1].shape
        ),
        broadcast.reduce_gradient(
            gradient:neg(),
            inputs[2].shape
        )
    }
end

return Sub