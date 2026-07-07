local Context = require("lunatic.math.autograd.context")

local Engine = {}

function Engine.backward(tensor, gradient)

    assert(
        tensor.grad_fn ~= nil,
        "Tensor does not have a computation graph"
    )

    local node = tensor.grad_fn

    Context.disable()

    local gradients = node:backward(gradient)

    Context.enable()

    for i, input in ipairs(node.inputs) do

        local grad = gradients[i]

        if input.grad == nil then
            input.grad = grad
        else
            input.grad = input.grad + grad
        end

    end

end

return Engine