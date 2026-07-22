local Mul = {}

function Mul.backward(gradient, inputs, output)

    local a = inputs[1]
    local b = inputs[2]

    return {
        gradient * b,
        gradient * a
    }

end

return Mul