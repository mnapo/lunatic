local reduction = {}

reduction.factory = nil

function reduction.init(factory)
    reduction.factory = factory
end

local function ensure_factory()
    assert(reduction.factory, "reduction: factory not initialized")
end

return reduction