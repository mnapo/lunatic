local Add = {}

function Add.backward(gradient, inputs, output)

    return {
        gradient,
        gradient
    }

end

return Add