local factory = {}

local constructor = nil


function factory.init(fn)

    assert(
        type(fn) == "function",
        "tensor_factory.init(): expected function"
    )

    constructor = fn

end


function factory.create(data, shape)

    assert(
        constructor,
        "tensor_factory: not initialized"
    )

    return constructor(data, shape)

end

return factory