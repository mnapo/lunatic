local Div = {}

function Div.backward(gradient, inputs)

    local a = inputs[1]
    local b = inputs[2]

    return {
        gradient / b,
        -(gradient * a) / (b * b)
    }

end

return Div