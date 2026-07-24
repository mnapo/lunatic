local Node = {}
Node.__index = Node

function Node.new(operation, inputs, backward_fn)

    assert(type(operation) == "string",
        "Node.new(): operation must be string")

    assert(type(inputs) == "table",
        "Node.new(): inputs must be table")

    assert(type(backward_fn) == "function",
        "Node.new(): backward_fn must be function")

    local self = setmetatable({}, Node)

    self.operation = operation
    self.inputs = inputs
    self.backward_fn = backward_fn
    self.output = nil
    self.saved = {}

    return self
end

function Node:set_output(tensor)
    self.output = tensor
end

function Node:save(key, value)
    self.saved[key] = value
end

function Node:backward(gradient)

    return self.backward_fn(
        gradient,
        self.inputs,
        self.output,
        self.saved
    )

end


return Node