local broadcast = require("lunatic.math.broadcast")

local Add = {}

function Add.backward(gradient, inputs)
    return {

        broadcast.reduce_gradient(
            gradient,
            inputs[1].shape
        ),

        broadcast.reduce_gradient(
            gradient,
            inputs[2].shape
        )

    }
end

return Add