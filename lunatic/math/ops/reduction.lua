local stride = require("lunatic.math.internal.stride")
local indexing = require("lunatic.math.internal.indexing")
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
    assert(
        reduction.factory,
        "reduction: factory not initialized"
    )
end


--
-- Helpers
--

local function zeros(size)

    local out = {}

    for i = 1, size do
        out[i] = 0
    end

    return out

end


local function reduced_shape(input_shape, axis, keepdim)

    local out = {}

    if keepdim then

        for i = 1, #input_shape do
            out[i] = input_shape[i]
        end

        out[axis] = 1

    else

        for i = 1, #input_shape do

            if i ~= axis then
                out[#out + 1] = input_shape[i]
            end

        end

    end

    return out

end


local function reduce_coords(coords, axis, keepdim)

    local out = {}

    if keepdim then

        for i = 1, #coords do
            out[i] = coords[i]
        end

        out[axis] = 1

    else

        for i = 1, #coords do

            if i ~= axis then
                out[#out + 1] = coords[i]
            end

        end

    end

    return out

end


--
-- Internal reductions
--

local function reduce_all(tensor, initial, reducer)

    local acc = initial

    for i = 1, tensor.size do
        acc = reducer(
            acc,
            tensor.storage:get(i)
        )
    end

    return acc

end


local function sum_axis(tensor, axis, keepdim)

    assert(
        axis >= 1
        and axis <= tensor.ndim,
        "reduction.sum_axis(): invalid axis"
    )

    if keepdim == nil then
        keepdim = true
    end


    local out_shape = reduced_shape(
        tensor.shape,
        axis,
        keepdim
    )

    local out_size = 1

    for i = 1, #out_shape do
        out_size = out_size * out_shape[i]
    end


    local data = zeros(out_size)

    local out_strides = stride.compute(
        out_shape
    )


    for i = 1, tensor.size do

        local coords = indexing.unravel(
            tensor.shape,
            i
        )

        local out_coords = reduce_coords(
            coords,
            axis,
            keepdim
        )

        local out_index = indexing.compute(
            out_shape,
            out_strides,
            0,
            out_coords
        )

        data[out_index] =
            data[out_index]
            + tensor.storage:get(i)

    end


    return reduction.factory(
        data,
        out_shape
    )

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


reduction.sum_axis = sum_axis

return reduction