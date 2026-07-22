local Context = require("lunatic.math.autograd.context")

local Engine = {}


local function build_graph(tensor, visited, nodes)

    if tensor.grad_fn == nil then
        return
    end

    local node = tensor.grad_fn

    if visited[node] then
        return
    end

    visited[node] = true

    for _, input in ipairs(node.inputs) do
        build_graph(input, visited, nodes)
    end

    table.insert(nodes, node)

end


function Engine.backward(tensor, gradient)

    assert(
        tensor.grad_fn ~= nil,
        "Tensor does not have a computation graph"
    )

    local nodes = {}

    build_graph(
        tensor,
        {},
        nodes
    )


    tensor.grad = gradient


    Context.disable()


    for i = #nodes, 1, -1 do

        local node = nodes[i]

        local output_grad = node.output.grad

        local gradients = node:backward(
            output_grad
        )


        for j, input in ipairs(node.inputs) do

            local grad = gradients[j]

            if input.grad == nil then
                input.grad = grad
            else
                input.grad = input.grad + grad
            end

        end

    end


    Context.enable()

end


return Engine