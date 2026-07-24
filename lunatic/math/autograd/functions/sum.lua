local TensorFactory = require("lunatic.math.internal.tensor_factory")

local Sum = {}

function Sum.backward(gradient, inputs)

    local input = inputs[1]

    local value = gradient:get(1)

    local data = {}

    for i = 1, input.size do
        data[i] = value
    end

    return {
        TensorFactory.create(
            data,
            input.shape
        )
    }

end

return Sum