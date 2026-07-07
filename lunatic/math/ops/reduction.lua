local reduction = {}

reduction.factory = nil

function reduction.init(factory)
    reduction.factory = factory
end

local function ensure_factory()
    assert(reduction.factory, "reduction: factory not initialized")
end

--
-- Internal
--

local function reduce_all(tensor, initial, reducer)
    local acc = initial

    for i = 1, tensor.size do
        acc = reducer(acc, tensor.storage:get(i))
    end

    return acc
end

--
-- Public API
--

function reduction.sum(tensor)
    return reduce_all(tensor, 0, function(acc, value)
        return acc + value
    end)
end

function reduction.mean(tensor)
    return reduction.sum(tensor) / tensor.size
end

return reduction