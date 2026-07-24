local Neg = {}

function Neg.backward(gradient)

    return {
        -gradient
    }

end

return Neg