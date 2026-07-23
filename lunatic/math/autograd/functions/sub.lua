local Sub = {}

function Sub.backward(gradient, inputs)

    return {
        gradient,
        -gradient
    }

end

return Sub