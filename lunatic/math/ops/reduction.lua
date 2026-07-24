local Node = require("lunatic.math.autograd.node")
local Context = require("lunatic.math.autograd.context")
local SumGrad = require("lunatic.math.autograd.functions.sum")
local MeanGrad = require("lunatic.math.autograd.functions.mean")

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

    ensure_factory()

    local value = reduce_all(
        tensor,
        0,
        function(acc, value)
            return acc + value
        end
    )

    local result = reduction.factory(
        {value},
        {1}
    )


    if Context.is_enabled()
        and tensor.requires_grad then

        local node = Node.new(
            "sum",
            {tensor},
            SumGrad.backward
        )

        node:set_output(result)

        result.requires_grad = true
        result.grad_fn = node

    end

    return result

end

function reduction.mean(tensor)

    ensure_factory()

    local value = reduce_all(
        tensor,
        0,
        function(acc, value)
            return acc + value
        end
    )

    value = value / tensor.size

    local result = reduction.factory(
        {value},
        {1}
    )

    if Context.is_enabled()
        and tensor.requires_grad then

        local node = Node.new(
            "mean",
            {tensor},
            MeanGrad.backward
        )

        node:set_output(result)

        result.requires_grad = true
        result.grad_fn = node

    end

    return result

end


return reduction