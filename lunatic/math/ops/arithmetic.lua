local indexing = require("lunatic.math.internal.indexing")
local broadcast = require("lunatic.math.broadcast")
local shape = require("lunatic.math.shape")

local arithmetic = {}

--
-- Tensor Factory injection
--

arithmetic.factory = nil

function arithmetic.init(factory)
    arithmetic.factory = factory
end

--
-- Helpers
--

local function elementwise(a, b, op)
    local size = a.size
    local data = {}

    local a_storage = a.storage:raw()
    local b_storage = b.storage:raw()

    for i = 1, size do
        data[i] = op(a_storage[i], b_storage[i])
    end

    return data
end

local function elementwise_scalar(a, scalar, op)
    local size = a.size
    local data = {}

    local a_storage = a.storage:raw()

    for i = 1, size do
        data[i] = op(a_storage[i], scalar)
    end

    return data
end

--
-- Guard: ensure initialization
--

local function ensure_factory()
    assert(arithmetic.factory, "arithmetic: factory not initialized")
end

--
-- Ops
--

function arithmetic.add(a, b)
    ensure_factory()

    local out_shape = Broadcast.resolve(a.shape, b.shape)
    local out_size = Shape.size(out_shape)

    local data = {}

    for i = 1, out_size do

        -- output linear -> multi-index
        local out_idx = indexing.unravel(out_shape, i)

        -- broadcast mapping
        local idxA, idxB = broadcast.map_index(
            out_idx,
            a.shape,
            b.shape,
            out_shape
        )

        -- multi-index -> linear index
        local linA = indexing.compute(a.shape, a.strides, a.offset, idxA)
        local linB = indexing.compute(b.shape, b.strides, b.offset, idxB)

        -- access storage
        local va = a.storage:get(linA)
        local vb = b.storage:get(linB)

        data[i] = va + vb
    end

    return arithmetic.factory(data, out_shape)
end

function arithmetic.sub(a, b)
    ensure_factory()
    assert(a.size == b.size, "sub: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x - y
    end)

    return arithmetic.factory(data, a.shape)
end

function arithmetic.mul(a, b)
    ensure_factory()
    assert(a.size == b.size, "mul: size mismatch")

    local data = elementwise(a, b, function(x, y)
        return x * y
    end)

    return arithmetic.factory(data, a.shape)
end

function arithmetic.scale(a, scalar)
    ensure_factory()

    local data = elementwise_scalar(a, scalar, function(x, s)
        return x * s
    end)

    return arithmetic.factory(data, a.shape)
end

function arithmetic.neg(a)
    ensure_factory()

    local data = elementwise_scalar(a, 0, function(_, x)
        return -x
    end)

    return arithmetic.factory(data, a.shape)
end

return arithmetic